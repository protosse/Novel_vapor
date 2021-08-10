//
//  Created by liuliu on 2021/8/9.
//

import Fluent
import Vapor

final class Book: Model, Content {
    static let schema = Book.v20210810.schemaName

    @ID(custom: Book.v20210810.id)
    var id: Int?

    @Field(key: Book.v20210810.title)
    var title: String

    @Field(key: Book.v20210810.author)
    var author: String

    @OptionalField(key: Book.v20210810.img)
    var img: String?

    @OptionalField(key: Book.v20210810.intro)
    var intro: String?

    @Timestamp(key: Book.v20210810.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: Book.v20210810.updatedAt, on: .update)
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
