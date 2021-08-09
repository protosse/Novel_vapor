//
//  Created by liuliu on 2021/8/9.
//

import Fluent
import Vapor

final class BookChapter: Model, Content {
    static let schema = "book_chapters"

    @ID(custom: "id")
    var id: Int?

    @Field(key: "title")
    var title: String

    @Field(key: "content")
    var content: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Parent(key: "bookId")
    var book: Book

    init() {}
}
