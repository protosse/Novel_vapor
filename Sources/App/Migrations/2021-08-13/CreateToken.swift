//
//  Created by liuliu on 2021/8/13.
//

import Fluent

struct CreateToken: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Token.v20210813.schemaName)
            .field(Token.v20210813.id, .int, .identifier(auto: true))
            .field(Token.v20210813.value, .string, .required)
            .field(Token.v20210813.userID, .int, .required,
                   .references(User.v20210813.schemaName, User.v20210813.id, onDelete: .cascade))
            .field(Token.v20210813.createdAt, .date)
            .field(Token.v20210813.expiresAt, .date)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Token.v20210813.schemaName).delete()
    }
}

extension Token {
    enum v20210813 {
        static let schemaName = "tokens"
        static let id = FieldKey(stringLiteral: "id")
        static let value = FieldKey(stringLiteral: "value")
        static let userID = FieldKey(stringLiteral: "user_id")
        static let expiresAt = FieldKey(stringLiteral: "expires_at")
        static let createdAt = FieldKey(stringLiteral: "created_at")
    }
}
