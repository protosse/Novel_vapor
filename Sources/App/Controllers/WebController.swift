//
//  Created by liuliu on 2021/8/17.
//

import Leaf
import Vapor

struct WebsiteController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get(use: indexHandler)
    }
    
    func indexHandler(_ req: Request) -> EventLoopFuture<View> {
        let context = IndexContext(title: "Home Page")
        return req.view.render("index", context)
    }
}

struct IndexContext: Encodable {
    let title: String
}
