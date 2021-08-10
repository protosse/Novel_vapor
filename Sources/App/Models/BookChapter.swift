//
//  Created by liuliu on 2021/8/9.
//

import Fluent
import Vapor

final class BookChapter: Model, Content {
    @ID(custom: BookChapter.v20210810.id)
    var id: Int?

    @Field(key: BookChapter.v20210810.title)
    var title: String

    @Field(key: BookChapter.v20210810.content)
    var content: String

    @Timestamp(key: BookChapter.v20210810.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: BookChapter.v20210810.updatedAt, on: .update)
    var updatedAt: Date?

    @Parent(key: BookChapter.v20210810.bookId)
    var book: Book

    init() {}
}
