//
//  XWeatherServer.swift
//  XWeatherKit
//
//  Created by teenloong on 2022/5/29.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
#if canImport(RxSwift)
import RxSwift
#endif
#if canImport(Combine)
import Combine
#endif

extension Encodable {
    fileprivate func toData() -> Data? { return try? JSONEncoder().encode(self) }
    
    fileprivate func toDictionary() -> [String: Any]? {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any]
    }
}

public struct XWHTTPMethod: RawRepresentable, Equatable, Hashable {
    public static let get = XWHTTPMethod(rawValue: "GET")
    public static let post = XWHTTPMethod(rawValue: "POST")
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
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
    
    var method: XWHTTPMethod { get }
    var host: String { get }
    var path: String { get }
    var url: String { get }
    var httpHeaders: [String: String]? { get }
    var timeoutInterval: TimeInterval { get }
    
    var parameters: Parameters? { get }
}

public extension XWeatherServerAction {
    var method: XWHTTPMethod { .get }
    var path: String { "/" }
    var url: String { host + path }
    var httpHeaders: [String: String]? { ["Content-Type": "application/json"] }
    var timeoutInterval: TimeInterval { 20 }
    var parameters: XWeatherServerEmptyParameters? { nil }
}

public let XWeather = XWeatherServer.shared

public class XWeatherServer {
    public static let shared = XWeatherServer()
    private var debug: Bool = false
    
    public init() { }
    
    public func debug(_ value: Bool = true) -> Self {
        debug = value
        return self
    }
}

extension XWeatherServer {
    public static func makeRequest<Action: XWeatherServerAction>(action: Action) -> URLRequest? {
        guard let url: URL = URL(string: action.url), var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        if action.method == .get {
            urlComponents.queryItems = XWURLQueryItemEncoding.default.encode(parameters: action.parameters?.toDictionary())
        }
        //        if let headers = action.httpHeaders {
        //            defaultHttpHeader.merge(headers) { current, new in
        //                new
        //            }
        //        }
        let u = urlComponents.url!
        var request = URLRequest(url: u)
        request.httpMethod = action.method.rawValue
        request.allHTTPHeaderFields = action.httpHeaders
        request.timeoutInterval = action.timeoutInterval
        if action.method == .post {
            request.httpBody =  try? JSONEncoder().encode(action.parameters)
        }
        return request
    }
    
    @discardableResult
    public func request<Action: XWeatherServerAction>(action: Action, completion: @escaping (Result<Action.Response, Error>) -> Void) -> URLSessionDataTask? {
        let enableDEBUG = debug
        guard let request = Self.makeRequest(action: action) else {
            return nil
        }
        let task = URLSession.shared.dataTask(with: request) { responseData, urlResponse, error in
            if enableDEBUG {
                Self.debugInfo(action: action, data: responseData, urlResponse: urlResponse)
            }
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            
            guard let data = responseData, !data.isEmpty else {
                DispatchQueue.main.async {
                    completion(.failure(XWeatherServerError.noResponseData))
                }
                return
            }
            
            do {
                if Action.Response.self == Data.self {
                    DispatchQueue.main.async {
                        completion(.success(data as! Action.Response))
                    }
                } else if Action.Response.self == String.self {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        DispatchQueue.main.async {
                            completion(.success(jsonString as! Action.Response))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(XWeatherServerError.decodeJSONDataToUTF8StringError))
                        }
                    }
                } else {
                    let model = try JSONDecoder().decode(Action.Response.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(model))
                    }
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        return task
    }
}

#if canImport(Combine)
import Combine
extension XWeatherServer {
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func requestPublisher<Action: XWeatherServerAction>(action: Action) -> AnyPublisher<Action.Response, Error> {
        let enableDEBUG = debug
        guard let request = Self.makeRequest(action: action) else {
            return Fail(error: XWeatherServerError.makeURLRqeusetError).eraseToAnyPublisher()
        }

        let queue = DispatchQueue(label: "SH API Queue", qos: .default, attributes: .concurrent)
        
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: queue)
            .receive(on: queue)
            .map { data, urlResponse -> Data in
                if enableDEBUG {
                    print(String(data: data, encoding: .utf8) ?? "data is nil")
                }
                return data
            }
        if Action.Response.self == Data.self {
            return publisher
                .map { return $0 as! Action.Response }
                .mapError { error in
                    error
                }
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        } else if Action.Response.self == String.self {
            return publisher
                .map { return (String(data: $0, encoding: .utf8) ?? "data is nil") as! Action.Response}
                .mapError { error in
                    error
                }
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        } else {
            let decoder = JSONDecoder()
            return publisher
                .decode(type: Action.Response.self, decoder: decoder)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        }
    }
}
#endif

extension XWeatherServer {
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func requestAsync<Action: XWeatherServerAction>(action: Action) async -> Result<Action.Response, Error> {
        let enableDEBUG = debug
        guard let request = Self.makeRequest(action: action) else {
            return .failure(XWeatherServerError.makeURLRqeusetError)
        }

        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: request, delegate: nil)
            if enableDEBUG {
                Self.debugInfo(action: action, data: data, urlResponse: urlResponse)
            }
            if Action.Response.self == Data.self {
                return .success(data as! Action.Response)
            } else if Action.Response.self == String.self {
                if let jsonString = String(data: data, encoding: .utf8) {
                    return .success(jsonString as! Action.Response)
                } else {
                    return .failure(XWeatherServerError.decodeJSONDataToUTF8StringError)
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

#if canImport(RxSwift)
extension XWeatherServer {
    public func requestObservable<Action: XWeatherServerAction>(action: Action) -> Single<Action.Response> {
        let enableDEBUG = debug

        return Single.create { observer in
            guard let request = Self.makeRequest(action: action) else {
                observer(.failure(XWeatherServerError.makeURLRqeusetError))
                return Disposables.create { }
            }
            let task = URLSession.shared.dataTask(with: request) { responseData, urlResponse, error in
                if enableDEBUG {
                    Self.debugInfo(action: action, data: responseData, urlResponse: urlResponse)
                }
                DispatchQueue.main.async {
                    guard error == nil else {
                        observer(.failure(error!))
                        return
                    }
                    
                    guard let data = responseData, !data.isEmpty else {
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
                                observer(.failure(XWeatherServerError.decodeJSONDataToUTF8StringError))
                            }
                        } else {
                            let model = try JSONDecoder().decode(Action.Response.self, from: data)
                            observer(.success(model))
                        }
                    } catch let error {
                        observer(.failure(error))
                    }
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
#endif

extension XWeatherServer {
    static private func DEBUGRequest(urlResponse: URLResponse) {
        print(urlResponse)
    }
    
    fileprivate static func debugInfo<Action: XWeatherServerAction>(action: Action, data: Data?, urlResponse: URLResponse?) {
        print("###SHAPIServer DEBUG info start###")
        print("parameters:")
        print(action.parameters?.toDictionary() ?? [String: Any]())
        print("response data:")
        if let data = data {
            print(String(data: data, encoding: .utf8) ?? "data is nil")
        } else {
            print("data is nil")
        }
        print("###SHAPIServer DEBUG info end###")
    }
}
