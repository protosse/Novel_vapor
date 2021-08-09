//
//  Created by liuliu on 2021/8/9.
//

import Fluent
import Vapor

enum BookCategoryStatus: Int, Codable {
    case invisible = 0
    case visible = 1
}

final class BookCategory: Model, Content {
    static let schema = "book-categories"

    @ID(custom: "id")
    var id: Int?

    @Field(key: "cat_name")
    var catName: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Field(key: "status")
    var status: BookCategoryStatus

    @Siblings(through: BookCategoryPivot.self, from: \.$bookCategory, to: \.$book)
    var books: [Book]

    init() {}

    init(catName: String, status: BookCategoryStatus = .visible) {
        self.catName = catName
        self.status = status
    }
}
