//
//  Created by liuliu on 2021/8/13.
//

import Fluent
import Vapor

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("api", "users")
        usersRoute.post("signup", use: signup)
        usersRoute.post("login", use: login)

        let tokenAuthMiddleware = Token.authenticator()
        let guardAuthMiddleware = User.guardMiddleware()
        let tokenAuthGroup = usersRoute.grouped(tokenAuthMiddleware, guardAuthMiddleware)

        tokenAuthGroup.post("info", use: info)
    }

    func signup(_ req: Request) throws -> EventLoopFuture<ResponseEmpty> {
        try UserSignUpParam.validate(content: req)
        let param = try req.content.decode(UserSignUpParam.self)
        let user = try User.create(from: param)

        return User.getUser(username: param.username, req.db)
            .guard({ $0 == nil }, else: ResponseError.usernameTaken)
            .transform(to: user.save(on: req.db).responseEmpty())
    }

    func login(_ req: Request) throws -> EventLoopFuture<ResponseData<UserLoginResult>> {
        try UserSignUpParam.validate(content: req)
        let param = try req.content.decode(UserLoginParam.self)
        return User.getUser(username: param.username, req.db)
            .unwrap(or: ResponseError.userNotExist)
            .guard({ (try? $0.verify(password: param.password)) ?? false }, else: ResponseError.userNotExist)
            .flatMapThrowing({ user -> (User.Public, Token) in
                req.auth.login(user)
                let token = try Token.generate(for: user)
                return (user.asPublic(), token)
            })
            .flatMap({ pub, token in
                token.save(on: req.db)
                    .transform(to: ResponseData(data: UserLoginResult(token: token.value, user: pub)))
            })
    }

    func info(_ req: Request) throws -> ResponseData<User.Public> {
        let pub = try req.auth.require(User.self).asPublic()
        return ResponseData(data: pub)
    }
}

extension UsersController {
    func getUser(username: String, _ req: Request) -> EventLoopFuture<User?> {
        User.query(on: req.db).filter(\.$username == username).first()
    }

    func checkIfUserExists(_ username: String, _ req: Request) -> EventLoopFuture<Bool> {
        User.query(on: req.db).filter(\.$username == username).first().map { $0 != nil }
    }
}
