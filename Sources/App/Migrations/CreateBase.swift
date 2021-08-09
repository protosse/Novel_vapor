//
//  Created by liuliu on 2021/8/9.
//

import Fluent

struct CreateBase: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let book = database.schema(Book.schema)
            .field("id", .int, .identifier(auto: true))
            .field("title", .string, .required)
            .field("author", .string, .required)
            .field("img", .string)
            .field("intro", .string)
            .field("created_at", .date)
            .field("updated_at", .date)
            .create()

        let category = database.schema(BookCategory.schema)
            .field("id", .int, .identifier(auto: true))
            .field("cat_name", .string, .required)
            .field("status", .int, .required)
            .field("created_at", .date)
            .field("updated_at", .date)
            .create()

        let pivot = database.schema(BookCategoryPivot.schema)
            .field("id", .int, .identifier(auto: true))
            .field("book_id", .int, .required, .references(Book.schema, "id", onDelete: .cascade))
            .field("bookCategory_id", .int, .required, .references(BookCategory.schema, "id", onDelete: .cascade))
            .create()

        let chapter = database.schema(BookChapter.schema)
            .field("id", .int, .identifier(auto: true))
            .field("title", .string, .required)
            .field("content", .string, .required)
            .field("created_at", .date)
            .field("updated_at", .date)
            .field("bookId", .int, .required, .references(Book.schema, "id"))
            .create()

        return EventLoopFuture.andAllSucceed([book, category, pivot, chapter], on: database.eventLoop)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        let chapter = database.schema(BookChapter.schema).delete()
        let pivot = database.schema(BookCategoryPivot.schema).delete()
        let category = database.schema(BookCategory.schema).delete()
        let book = database.schema(Book.schema).delete()
        return EventLoopFuture.andAllSucceed([chapter, pivot, category, book], on: database.eventLoop)
    }
}
