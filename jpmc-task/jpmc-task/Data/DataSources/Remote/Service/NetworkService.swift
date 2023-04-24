//
//  NetworkService.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 20/04/2023.
//

import Combine
import Foundation

protocol NetworkServiceProtocol {
    func get<T: Decodable, S: Endpoint>(_ t: T.Type, endpoint: S) -> AnyPublisher<T, Error>
}

class NetworkService: NetworkServiceProtocol {
    private var urlSession: URLSession

    init(urlSessionConfiguration: URLSessionConfiguration? = nil) {
        let configuration = urlSessionConfiguration ?? URLSessionConfiguration.default
        urlSession = URLSession(configuration: configuration)
    }

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
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200 ..< 400).contains(httpResponse.statusCode)
                else {
                    throw APIError.badURLResponse(url: request.url?.absoluteString ?? "")
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .background))
            .retry(3)
            .eraseToAnyPublisher()
    }
}
