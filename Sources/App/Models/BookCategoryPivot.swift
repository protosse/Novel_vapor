//
//  Created by liuliu on 2021/8/9.
//

import Fluent
import Vapor

final class BookCategoryPivot: Model, Content {
    static let schema = "book-category-pivot"

    @ID(custom: "id")
    var id: Int?

    @Parent(key: "book_id")
    var book: Book

    @Parent(key: "bookCategory_id")
    var bookCategory: BookCategory

    init() {}

    init(id: Int? = nil, book: Book, bookCategory: BookCategory) throws {
        self.id = id
        $book.id = try book.requireID()
        $bookCategory.id = try bookCategory.requireID()
    }
}
