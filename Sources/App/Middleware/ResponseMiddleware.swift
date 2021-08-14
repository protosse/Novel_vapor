//
//  Created by liuliu on 2021/8/14.
//

import Foundation
import Vapor

struct Empty: Content {}

struct ResponseData<T: Content>: Content {
    var code: UInt = 200
    var msg: String = ""
    @NullContent var data: T? = nil
    var time = String(format: "%.0f", Date().timeIntervalSince1970)
}

typealias ResponseEmpty = ResponseData<Empty>

final class ResponseMiddleware: Middleware {
    let environment: Environment

    init(environment: Environment) {
        self.environment = environment
    }

    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        let start = Date()
        return next.respond(to: request)
            .map({ response in
                self.log(response, start: start, for: request, data: response.body, isError: false)
                return response
            })
            .flatMapErrorThrowing { error in
                self.responseError(start, req: request, error: error)
            }
    }

    func responseError(_ start: Date, req: Request, error: Error) -> Response {
        let status: HTTPResponseStatus
        let reason: String

        switch error {
        case let abort as AbortError:
            reason = abort.reason
            status = abort.status
        default:
            reason = environment.isRelease
                ? "Something went wrong."
                : String(describing: error)
            status = .internalServerError
        }

        let response = Response(status: .ok)

        // attempt to serialize the error to json
        do {
            let errorResponse = ResponseData<String>(code: status.code, msg: reason, data: nil)
            response.body = try .init(data: JSONEncoder().encode(errorResponse))
            response.headers.replaceOrAdd(name: .contentType, value: "application/json; charset=utf-8")
        } catch {
            response.body = .init(string: "Oops: \(error)")
            response.headers.replaceOrAdd(name: .contentType, value: "text/plain; charset=utf-8")
        }

        log(response, start: start, for: req, data: response.body, isError: true)

        return response
    }

    func log(_ res: Response, start: Date, for req: Request, data: Any, isError: Bool) {
        let reqInfo = "\(req.method.string) \(req.url.path)"
        let resInfo = "\(res.status.code) " + "\(res.status.reasonPhrase)"
        let time = Date().timeIntervalSince(start).readableMilliseconds
        var info = "\(reqInfo) -> \(resInfo) [\(time)]"
        info = info + "\n\(String(describing: data))\n"

        if !isError {
            req.logger.info("\(info)")
        } else {
            req.logger.error("\(info)")
        }
    }
}

@propertyWrapper
struct NullContent<T>: Content where T: Content {
    var wrappedValue: T?

    init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch wrappedValue {
        case let .some(value): try container.encode(value)
        case .none: try container.encodeNil()
        }
    }
}

extension TimeInterval {
    /// Converts the time internal to readable milliseconds format, i.e., "3.4ms"
    var readableMilliseconds: String {
        let string = (self * 1000).description
        // include one decimal point after the zero
        let endIndex = string.index(string.firstIndex(of: ".")!, offsetBy: 2)
        let trimmed = string[string.startIndex ..< endIndex]
        return .init(trimmed) + "ms"
    }
}

enum ResponseError: UInt {
    case usernameTaken = 600
    case userNotExist
    case passwordError
}

extension ResponseError: AbortError {
    var description: String {
        reason
    }

    var status: HTTPResponseStatus {
        return .custom(code: rawValue, reasonPhrase: "")
    }

    var reason: String {
        switch self {
        case .usernameTaken:
            return "用户名已被使用"
        case .userNotExist:
            return "用户不存在"
        case .passwordError:
            return "密码错误"
        }
    }
}
