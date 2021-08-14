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

        return checkIfUserExists(param.username, req).flatMap { exist in
            guard !exist else {
                return req.eventLoop.future(error: ResponseError.usernameTaken)
            }
            return user.save(on: req.db).map { ResponseEmpty() }
        }
    }

    func login(_ req: Request) throws -> EventLoopFuture<ResponseData<UserLoginResult>> {
        try UserSignUpParam.validate(content: req)
        let param = try req.content.decode(UserLoginParam.self)
        return User.query(on: req.db)
            .filter(\.$username == param.username)
            .first()
            .flatMapThrowing { user -> (User.Public, Token) in
                guard let user = user else {
                    throw ResponseError.userNotExist
                }
                guard try user.verify(password: param.password) else {
                    throw ResponseError.passwordError
                }

                let pub = try user.asPublic()
                let token = try Token.generate(for: user)
                req.auth.login(user)
                return (pub, token)
            }.flatMap { v in
                v.1.save(on: req.db).map {
                    ResponseData(data: UserLoginResult(token: v.1.value, user: v.0))
                }
            }
    }

    func info(_ req: Request) throws -> ResponseData<User.Public> {
        let pub = try req.auth.require(User.self).asPublic()
        return ResponseData(data: pub)
    }
}

extension UsersController {
    func checkIfUserExists(_ username: String, _ req: Request) -> EventLoopFuture<Bool> {
        User.query(on: req.db).filter(\.$username == username).first().map { $0 != nil }
    }
}
