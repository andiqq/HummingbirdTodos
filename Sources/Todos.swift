import ArgumentParser
import Hummingbird
import Logging

@main
struct Todos: AsyncParsableCommand, AppArguments {
    
    @Option(name: .shortAndLong)
    var hostname: String = "127.0.0.1"
    
    @Option(name: .shortAndLong)
    var port: Int = 8080
    
    @Flag
    var inMemoryTesting: Bool = false
    
    func run() async throws {
        
        let app = try await buildApplication(self)
        
        try await app.runService()
    }
}

protocol AppArguments {
    var hostname: String { get }
    var port: Int { get }
    var inMemoryTesting: Bool { get }
}

func buildApplication(_ args: some AppArguments) async throws -> some ApplicationProtocol {
    
    var logger = Logger(label: "Todos")
    logger.logLevel = .debug
    
    let router = Router()
    
    router.middlewares.add(LogRequestsMiddleware(.info))
    
    router.get("/") { request, context in
        "Hello\n"
    }
    
    TodoController(repository: TodoMemoryRepository()).addRoutes(to: router.group("todos"))
    
    let app = Application(
        router: router,
        configuration: .init(address: .hostname(args.hostname, port: args.port)),
        logger: logger
    )
    
    return app
}
