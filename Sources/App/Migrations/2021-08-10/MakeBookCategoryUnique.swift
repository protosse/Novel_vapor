//
//  Created by liuliu on 2021/8/10.
//

import Fluent

struct MakeBookCategoryUnique: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(BookCategory.v20210810.schemaName)
            .unique(on: BookCategory.v20210810.catName)
            .update()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(BookCategory.v20210810.schemaName)
            .deleteUnique(on: BookCategory.v20210810.catName)
            .update()
    }
}
