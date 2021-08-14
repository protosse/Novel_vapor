//
//  Created by liuliu on 2021/8/13.
//

import Fluent

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.v20210813.schemaName)
            .field(User.v20210813.id, .int, .identifier(auto: true))
            .field(User.v20210813.username, .string, .required)
            .unique(on: User.v20210813.username)
            .field(User.v20210813.password, .string, .required)
            .field(User.v20210813.createdAt, .date)
            .field(User.v20210813.updatedAt, .date)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.v20210813.schemaName).delete()
    }
}

extension User {
    enum v20210813 {
        static let schemaName = "users"
        static let id = FieldKey(stringLiteral: "id")
        static let username = FieldKey(stringLiteral: "username")
        static let password = FieldKey(stringLiteral: "password")
        static let createdAt = FieldKey(stringLiteral: "created_at")
        static let updatedAt = FieldKey(stringLiteral: "updated_at")
    }
}
