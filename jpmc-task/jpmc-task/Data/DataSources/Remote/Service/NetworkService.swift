//
//  NetworkService.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 20/04/2023.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func get<T: Decodable, S: Endpoint>(_ t: T.Type, endpoint: S) -> AnyPublisher<T, Error>
}

class NetworkService: NetworkServiceProtocol {
    
    private var urlSession: URLSession
    
    init(urlSessionConfiguration: URLSessionConfiguration? = nil) {
        let configuration = urlSessionConfiguration ?? URLSessionConfiguration.default
        urlSession = URLSession(configuration: configuration)
    }
    
    func get<T, S>(_ t: T.Type, endpoint: S) -> AnyPublisher<T, Error> where T : Decodable, S : Endpoint {

        guard let url = endpoint.makeURL() else {
            return Fail(error: APIError.badURLRequest(url: "\(endpoint.baseUrl)\(endpoint.path)"))
                .eraseToAnyPublisher()
        }

        let request = URLRequest(url: url)
        return load(request)
            .decode(type: T.self, decoder: JSONDecoder())
            .print()
            .eraseToAnyPublisher()
    }
    
    private func load(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        return urlSession.dataTaskPublisher(for: request)
            .mapError { _ in APIError.unknown }
            .tryMap({ data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<400).contains(httpResponse.statusCode) else {
                          throw APIError.badURLResponse(url: request.url?.absoluteString ?? "")
                      }
                return data
            })
            .retry(3)
            .eraseToAnyPublisher()
    }
}

