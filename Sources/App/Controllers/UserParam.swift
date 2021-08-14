//
//  Created by liuliu on 2021/8/14.
//

import Vapor

struct UserSignUpParam: Content {
    let username: String
    let password: String
}

extension UserSignUpParam: Validatable {
    static func validations(_ v: inout Validations) {
        v.add("username", as: String.self, is: !.empty)
        v.add("password", as: String.self, is: .count(6...))
    }
}

struct UserLoginParam: Content {
    let username: String
    let password: String
}

extension UserLoginParam: Validatable {
    static func validations(_ v: inout Validations) {
        v.add("username", as: String.self, is: !.empty)
        v.add("password", as: String.self, is: .count(6...))
    }
}

struct UserLoginResult: Content {
    let token: String
    let user: User.Public
}
