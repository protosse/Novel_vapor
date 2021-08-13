import Fluent
import FluentPostgresDriver
import Leaf
import Vapor
import Redis

// configures your application
public func configure(_ app: Application) throws {
    app.logger.logLevel = .debug

    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(LogMiddleware())

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)

    app.migrations.add(CreateBase())
    app.migrations.add(MakeBookCategoryUnique())
    app.migrations.add(CacheEntry.migration)

    try app.autoMigrate().wait()
    
    app.redis.configuration = try RedisConfiguration(hostname: "localhost")
    app.caches.use(.redis)

    app.views.use(.leaf)

    // register routes
    try routes(app)
}
