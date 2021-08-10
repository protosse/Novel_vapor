//
//  Created by liuliu on 2021/8/9.
//

import Fluent
import Vapor

final class BookCategoryPivot: Model, Content {
    @ID(custom: BookCategoryPivot.v20210810.id)
    var id: Int?

    @Parent(key:  BookCategoryPivot.v20210810.bookId)
    var book: Book

    @Parent(key:  BookCategoryPivot.v20210810.bookCategoryId)
    var bookCategory: BookCategory

    init() {}

    init(id: Int? = nil, book: Book, bookCategory: BookCategory) throws {
        self.id = id
        $book.id = try book.requireID()
        $bookCategory.id = try bookCategory.requireID()
    }
}
