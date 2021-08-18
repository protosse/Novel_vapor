//
//  Created by liuliu on 2021/8/13.
//

import Fluent
import Vapor

final class User: Model {
    struct Public: Content {
        let username: String
        let id: Int?
        let createdAt: Date?
    }

    static let schema = User.v20210813.schemaName

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

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$username
    static let passwordHashKey = \User.$password

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

// MARK: - Method

extension User {
    static func create(from param: UserSignUpParam) throws -> User {
        User(username: param.username, password: try Bcrypt.hash(param.password))
    }

    func asPublic() -> Public {
        Public(username: username, id: id, createdAt: createdAt)
    }
}

extension EventLoopFuture where Value: User {
    func asPublic() -> EventLoopFuture<User.Public> {
        map { $0.asPublic() }
    }
}

extension User {
    static func getUser(username: String, _ db: Database) -> EventLoopFuture<User?> {
        User.query(on: db).filter(\.$username == username).first()
    }
}
