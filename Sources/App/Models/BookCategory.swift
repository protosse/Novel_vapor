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
    @ID(custom: BookCategory.v20210810.id)
    var id: Int?

    @Field(key: BookCategory.v20210810.catName)
    var catName: String

    @Timestamp(key: BookCategory.v20210810.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: BookCategory.v20210810.updatedAt, on: .update)
    var updatedAt: Date?

    @Field(key: BookCategory.v20210810.status)
    var status: BookCategoryStatus

    @Siblings(through: BookCategoryPivot.self, from: \.$bookCategory, to: \.$book)
    var books: [Book]

    init() {}

    init(catName: String, status: BookCategoryStatus = .visible) {
        self.catName = catName
        self.status = status
    }
}
