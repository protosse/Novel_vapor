//
//  Created by liuliu on 2021/8/13.
//

import Fluent
import Vapor

final class User: Model {
    struct Public: Content {
        let username: String
        let id: UUID
        let createdAt: Date?
    }

    @ID(custom: User.v20210813.id)
    var id: Int?

    @Field(key: User.v20210813.username)
    var username: String

    @Field(key: User.v20210813.password)
    var password: String

    @Timestamp(key: User.v20210813.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: User.v20210813.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() {}

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

extension User {
    static func create(from param: UserSignUpParam) throws -> User {
        User(username: param.username, password: try Bcrypt.hash(param.password))
    }
    
    
}
