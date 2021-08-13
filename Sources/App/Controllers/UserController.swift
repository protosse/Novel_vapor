//
//  Created by liuliu on 2021/8/13.
//

import Fluent
import Vapor

struct UserSignUpParam: Content {
    let username: String
    let password: String
}

struct UserSignUpResult: Content {
    let token: String
    let user: User.Public
}

extension UserSignUpParam: Validatable {
    static func validations(_ v: inout Validations) {
        v.add("username", as: String.self, is: !.empty)
        v.add("password", as: String.self, is: .count(6...))
    }
}

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("api", "users")
        usersRoute.post("signup", use: signup)
        
        usersRoute.post("info", use: info)
    }
    
    func signup(_ req: Request) -> EventLoopFuture<UserSignUpResult> {
        try UserSignUpParam.validate(req)
        let param = try req.content.decode(UserSignUpParam.self)
        let user = try User.create(from: param)
    }
    
    func info(_ req: Request) -> EventLoopFuture<User.Public> {
        
    }
}
