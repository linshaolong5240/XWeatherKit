//
//  XWeatherServer.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/5/29.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
import Alamofire
#if canImport(RxSwift)
import RxSwift
#endif
#if canImport(Combine)
import Combine
#endif

extension Encodable {
    
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
    func toData() -> Data? { return try? JSONEncoder().encode(self) }

    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
        
    func toDictionary() -> [String: Any] {
      let mirror = Mirror(reflecting: self)
      let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
        guard let label = label else { return nil }
        return (label, value)
      }).compactMap { $0 })
      return dict
    }
    
    func toDictionary() -> [String: Any]? {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any]
    }
    
    func toJSONString(encoding: String.Encoding = .utf8) -> String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return String(data: data, encoding: encoding)
    }
}

enum XWeatherServerError: Error {
    case decodeJSONDataToUTF8StringError
    case noResponseData
}

extension XWeatherServerError: LocalizedError  {
    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        switch self {
        case .decodeJSONDataToUTF8StringError:
            return "decode JSON data to utf8 string error"
        case .noResponseData:
            return "no response data"
        }
    }

    /// A localized message describing the reason for the failure.
    public var failureReason: String? {
        switch self {
        case .decodeJSONDataToUTF8StringError:
            return "decode JSON data to string error"
        case .noResponseData:
            return "no response data"
        }
    }

    /// A localized message describing how one might recover from the failure.
    public var recoverySuggestion: String? { nil }

    /// A localized message providing "help" text if the user requests help.
    public var helpAnchor: String? { nil }
}
public protocol XWeatherServerParameters: Codable { }
extension String: XWeatherServerParameters { }

public struct XWeatherServerEmptyParameters: XWeatherServerParameters { }

public protocol XWeatherServerResponse: Codable { }
extension Data: XWeatherServerResponse { }
extension String: XWeatherServerResponse { }

public protocol XWeatherServerAction {
    associatedtype Parameters: XWeatherServerParameters
    associatedtype Response: XWeatherServerResponse
    
    var method: HTTPMethod { get }
    var host: String { get }
    var uri: String { get }
    var url: String { get }
    var httpHeaders: [String: String]? { get }
    var timeoutInterval: TimeInterval { get }
    
    var parameters: Parameters? { get }
}

public extension XWeatherServerAction {
    var method: HTTPMethod { .get }
    var uri: String { "/" }
    var url: String { host + uri }
    var httpHeaders: [String: String]? { ["Content-Type": "application/json"] }
    var headers: HTTPHeaders? {
        guard let headers = httpHeaders else {
            return nil
        }
        
        return HTTPHeaders(headers)
    }
    var timeoutInterval: TimeInterval { 20 }
    var parameters: XWeatherServerEmptyParameters? { nil }
}

public let XWeather = XWeatherServer.shared

public class XWeatherServer {
    public static let shared = XWeatherServer()
    private var _debug: Bool = false
    
    public init() { }
    
    public func debug() -> Self {
        _debug = true
        return self
    }
}

extension XWeatherServer {
    @discardableResult
    public func request<Action: XWeatherServerAction>(action: Action, completionHandler: @escaping (Result<Action.Response, Error>) -> Void) -> DataRequest {
        let request =  AF.request(action.url,
                                 method: action.method,
                                 parameters: action.parameters.toDictionary(),
                                 encoding: action.method == .get ? URLEncoding.default : JSONEncoding.default,
                                  headers: action.headers, requestModifier: { $0.timeoutInterval = action.timeoutInterval })
            .response {[weak self] response in
                if self?._debug ?? false {
                    Self.DEBUGRequest(action: action, response: response)
                }
                
                guard response.error == nil else {
                    completionHandler(.failure(response.error!))
                    return
                }
                
                guard let data = response.data, !data.isEmpty else {
                    completionHandler(.failure(XWeatherServerError.noResponseData))
                    return
                }
                
                do {
                    if Action.Response.self == Data.self {
                        completionHandler(.success(data as! Action.Response))
                    } else if Action.Response.self == String.self {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            completionHandler(.success(jsonString as! Action.Response))
                        } else {
                            throw XWeatherServerError.decodeJSONDataToUTF8StringError
                        }
                    } else {
                        let model = try JSONDecoder().decode(Action.Response.self, from: data)
                        completionHandler(.success(model))
                    }
                } catch let error {
                    completionHandler(.failure(error))
                }
            }
        return request
    }
}

#if canImport(RxSwift)
extension XWeatherServer {
    public func requestObservable<Action: XWeatherServerAction>(action: Action) -> Single<Action.Response> {
        return Single.create { observer in
            let request = AF.request(action.url,
                                     method: action.method,
                                     parameters: action.parameters.toDictionary(),
                                     encoding: action.method == .get ? URLEncoding.default : JSONEncoding.default,
                                     headers: action.headers, requestModifier: { $0.timeoutInterval = action.timeoutInterval })
                .response { response in
                    if self._debug {
                        Self.DEBUGRequest(action: action, response: response)
                    }
                    
                    guard response.error == nil else {
                        observer(.failure(response.error!))
                        return
                    }
                    
                    guard let data = response.data, !data.isEmpty else {
                        observer(.failure(XWeatherServerError.noResponseData))
                        return
                    }
                    
                    do {
                        if Action.Response.self == Data.self {
                            observer(.success(data as! Action.Response))
                        } else if Action.Response.self == String.self {
                            if let jsonString = String(data: data, encoding: .utf8) {
                                observer(.success(jsonString as! Action.Response))
                            } else {
                                throw XWeatherServerError.decodeJSONDataToUTF8StringError
                            }
                        } else {
                            let model = try JSONDecoder().decode(Action.Response.self, from: data)
                            observer(.success(model))
                        }
                    } catch let error {
                        observer(.failure(error))
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
#endif

#if canImport(Combine)
extension XWeatherServer {
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func requestPublisher<Action: XWeatherServerAction>(action: Action) -> Future<Action.Response,Error> {
        return Future<Action.Response,Error> { promise in
            let _ = AF.request(action.url,
                       method: action.method,
                       parameters: action.parameters.toDictionary(),
                       encoding: action.method == .get ? URLEncoding.default : JSONEncoding.default,
                               headers: action.headers, requestModifier: { $0.timeoutInterval = action.timeoutInterval }).response { [weak self] response in
                if self?._debug ?? false {
                    Self.DEBUGRequest(action: action, response: response)
                }
                
                guard response.error == nil else {
                    promise(.failure(response.error!))
                    return
                }
                
                guard let data = response.data, !data.isEmpty else {
                    promise(.failure(XWeatherServerError.noResponseData))
                    return
                }
                
                do {
                    if Action.Response.self == Data.self {
                        return promise(.success(data as! Action.Response))
                    } else if Action.Response.self == String.self {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            promise(.success(jsonString as! Action.Response))
                            return
                        } else {
                            throw XWeatherServerError.decodeJSONDataToUTF8StringError
                        }
                    } else {
                        let model = try JSONDecoder().decode(Action.Response.self, from: data)
                        promise(.success(model))
                    }
                } catch let error {
                    promise(.failure(error))
                }
            }
        }
    }
}
#endif

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension XWeatherServer {
    public func requestAsync<Action: XWeatherServerAction>(action: Action) async -> Result<Action.Response, Error> {
        func makeRequest<Action: XWeatherServerAction>(action: Action) -> URLRequest {
            var request = URLRequest(url: URL(string: action.url)!)
            request.httpMethod = action.method.rawValue
            request.allHTTPHeaderFields = action.httpHeaders
            request.timeoutInterval = action.timeoutInterval
            request.httpBody = action.parameters?.toData()
            return request
        }
        
        let request = makeRequest(action: action)

        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: request, delegate: nil)
            if self._debug {
                Self.DEBUGRequest(urlResponse: urlResponse)
            }
            if Action.Response.self == Data.self {
                return .success(data as! Action.Response)
            } else if Action.Response.self == String.self {
                if let jsonString = String(data: data, encoding: .utf8) {
                    return .success(jsonString as! Action.Response)
                } else {
                    throw XWeatherServerError.decodeJSONDataToUTF8StringError
                }
            } else {
                let model = try JSONDecoder().decode(Action.Response.self, from: data)
                return .success(model)
            }
        } catch let error {
            return .failure(error)
        }
    }
}

extension XWeatherServer {
    static private func DEBUGRequest(urlResponse: URLResponse) {
        print(urlResponse)
    }
    
    static private func DEBUGRequest<Action: XWeatherServerAction>(action: Action, response: AFDataResponse<Data?>) {
        print("parameters:")
        print(action.parameters?.toDictionary() ?? [String: Any]())
        print("request:")
        if let request = response.request {
            print(request)
        }
        print("HTTPHeader:")
        if let httpHeader = response.request?.allHTTPHeaderFields {
            print(httpHeader)
        }
        print("HTTPBody:")
        if let httpBody = response.request?.httpBody {
            print(String(data: httpBody, encoding: .utf8) ?? "nil")
        }
        print("response data:")
        if let data = response.data {
            print(data)
            print("response data string:")
            print(String(data: data, encoding: .utf8) ?? "nil")

        }
        print("response error:")
        if let error = response.error {
            print(error)
        }
    }
}
