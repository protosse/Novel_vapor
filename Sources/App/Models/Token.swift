//
//  Created by liuliu on 2021/8/13.
//

import Fluent
import Vapor

final class Token: Model, Content {
    static let schema = Token.v20210813.schemaName

    @ID(custom: Token.v20210813.id)
    var id: Int?

    @Field(key: Token.v20210813.value)
    var value: String

    @Parent(key: Token.v20210813.userID)
    var user: User

    @Field(key: Token.v20210813.expiresAt)
    var expiresAt: Date?

    @Timestamp(key: Token.v20210813.createdAt, on: .create)
    var createdAt: Date?

    init() {}

    init(value: String, userID: User.IDValue) {
        self.value = value
        $user.id = userID
    }
}

extension Token {
    static func generate(for user: User) throws -> Token {
        let random = [UInt8].random(count: 16).base64
        return try Token(value: random, userID: user.requireID())
    }
}

extension Token: ModelTokenAuthenticatable {
    static let valueKey = \Token.$value
    static let userKey = \Token.$user

    typealias User = App.User

    var isValid: Bool {
        guard let date = expiresAt else {
            return true
        }

        return date > Date()
    }
}
