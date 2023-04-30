//
//  NetworkService.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Combine
import Foundation

protocol NetworkServiceProtocol {
    func get<T: Decodable, S: Endpoint>(_ t: T.Type, endpoint: S) -> AnyPublisher<T, Error>
}

class NetworkService: NetworkServiceProtocol {
    private var urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession    }
    
    func get<T, S>(_: T.Type, endpoint: S) -> AnyPublisher<T, Error> where T: Decodable, S: Endpoint {
        guard let url = endpoint.makeURL() else {
            return Fail(error: APIError.badURLRequest(url: "\(endpoint.baseUrl)\(endpoint.path)"))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        return urlSession.dataTaskPublisher(for: request)
            .mapError { error -> Error in
                switch error {
                case URLError.timedOut:
                    return APIError.timeout
                default:
                    return APIError.unknown
                }
            }
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200 ..< 400).contains(httpResponse.statusCode)
                else {
                    throw APIError.badURLResponse(url: request.url?.absoluteString ?? "")
                }
                return data
            }
        
            .flatMap { data -> AnyPublisher<T, Error> in
                self.decodeResponse(data, ofType: T.self)
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    internal func decodeResponse<T: Decodable>(_ data: Data, ofType type: T.Type) -> AnyPublisher<T, Error> {
        do {
            let decoder = JSONDecoder()
            let object = try decoder.decode(type, from: data)
            return Just(object)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: APIError.decodingError)
                .eraseToAnyPublisher()
        }
    }
}
