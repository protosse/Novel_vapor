//
//  Created by liuliu on 2021/8/9.
//

import Fluent

struct CreateBase: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let book = database.schema(Book.v20210810.schemaName)
            .field(Book.v20210810.id, .int, .identifier(auto: true))
            .field(Book.v20210810.title, .string, .required)
            .field(Book.v20210810.author, .string, .required)
            .field(Book.v20210810.img, .string)
            .field(Book.v20210810.intro, .string)
            .field(Book.v20210810.createdAt, .date)
            .field(Book.v20210810.updatedAt, .date)
            .create()

        let category = database.schema(BookCategory.v20210810.schemaName)
            .field(BookCategory.v20210810.id, .int, .identifier(auto: true))
            .field(BookCategory.v20210810.catName, .string, .required)
            .field(BookCategory.v20210810.status, .int, .required)
            .field(BookCategory.v20210810.createdAt, .date)
            .field(BookCategory.v20210810.updatedAt, .date)
            .create()

        let pivot = database.schema(BookCategoryPivot.v20210810.schemaName)
            .field(BookCategoryPivot.v20210810.id, .int, .identifier(auto: true))
            .field(BookCategoryPivot.v20210810.bookId, .int, .required, .references(Book.v20210810.schemaName, "id", onDelete: .cascade))
            .field(BookCategoryPivot.v20210810.bookCategoryId, .int, .required,
                    .references(BookCategory.schema, "id", onDelete: .cascade))
            .create()

        let chapter = database.schema(BookChapter.v20210810.schemaName)
            .field(BookChapter.v20210810.id, .int, .identifier(auto: true))
            .field(BookChapter.v20210810.title, .string, .required)
            .field(BookChapter.v20210810.content, .string, .required)
            .field(BookChapter.v20210810.createdAt, .date)
            .field(BookChapter.v20210810.updatedAt, .date)
            .field(BookChapter.v20210810.bookId, .int, .required,
                    .references(Book.v20210810.schemaName, Book.v20210810.id))
            .create()

        return EventLoopFuture.andAllSucceed([book, category, pivot, chapter], on: database.eventLoop)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        let chapter = database.schema(BookChapter.v20210810.schemaName).delete()
        let pivot = database.schema(BookCategoryPivot.v20210810.schemaName).delete()
        let category = database.schema(BookCategory.v20210810.schemaName).delete()
        let book = database.schema(Book.v20210810.schemaName).delete()
        return EventLoopFuture.andAllSucceed([chapter, pivot, category, book], on: database.eventLoop)
    }
}

extension Book {
    enum v20210810 {
        static let schemaName = "books"
        static let id = FieldKey(stringLiteral: "id")
        static let title = FieldKey(stringLiteral: "title")
        static let author = FieldKey(stringLiteral: "author")
        static let img = FieldKey(stringLiteral: "img")
        static let intro = FieldKey(stringLiteral: "intro")
        static let createdAt = FieldKey(stringLiteral: "created_at")
        static let updatedAt = FieldKey(stringLiteral: "updated_at")
    }
}

extension BookCategory {
    enum v20210810 {
        static let schemaName = "book-categories"
        static let id = FieldKey(stringLiteral: "id")
        static let catName = FieldKey(stringLiteral: "cat_name")
        static let status = FieldKey(stringLiteral: "status")
        static let createdAt = FieldKey(stringLiteral: "created_at")
        static let updatedAt = FieldKey(stringLiteral: "updated_at")
    }
}

extension BookCategoryPivot {
    enum v20210810 {
        static let schemaName = "book-category-pivot"
        static let id = FieldKey(stringLiteral: "id")
        static let bookId = FieldKey(stringLiteral: "book_id")
        static let bookCategoryId = FieldKey(stringLiteral: "bookCategory_id")
    }
}

extension BookChapter {
    enum v20210810 {
        static let schemaName = "book-chapters"
        static let id = FieldKey(stringLiteral: "id")
        static let title = FieldKey(stringLiteral: "title")
        static let content = FieldKey(stringLiteral: "content")
        static let createdAt = FieldKey(stringLiteral: "created_at")
        static let updatedAt = FieldKey(stringLiteral: "updated_at")
        static let bookId = FieldKey(stringLiteral: "book_id")
    }
}
