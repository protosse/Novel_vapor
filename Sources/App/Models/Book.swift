//
//  Created by liuliu on 2021/8/9.
//

import Fluent
import Vapor

final class Book: Model, Content {
    static let schema = "books"

    @ID(custom: "id")
    var id: Int?

    @Field(key: "title")
    var title: String

    @Field(key: "author")
    var author: String

    @OptionalField(key: "img")
    var img: String?

    @OptionalField(key: "intro")
    var intro: String?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Siblings(through: BookCategoryPivot.self, from: \.$book, to: \.$bookCategory)
    var bookCategories: [BookCategory]

    @Children(for: \.$book)
    var chapters: [BookChapter]

    init() {}

    init(title: String, author: String, img: String? = nil, intro: String? = nil) {
        self.title = title
        self.author = author
        self.img = img
        self.intro = intro
    }
}
