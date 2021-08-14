import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello") { req -> EventLoopFuture<String> in
        req.redis.ping()
    }
    
    try app.register(collection: UsersController())
}
