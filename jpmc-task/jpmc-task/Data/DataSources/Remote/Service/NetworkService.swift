//
//  NetworkService.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Combine
import Foundation

protocol NetworkServiceProtocol {
    func get<T: Decodable, S: Endpoint>(_ t: T.Type, endpoint: S) -> AnyPublisher<T, DataSourceError>
}

class NetworkService: NetworkServiceProtocol {
    private var urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func get<T, S>(_: T.Type, endpoint: S) -> AnyPublisher<T, DataSourceError> where T: Decodable, S: Endpoint {
        guard let url = endpoint.makeURL() else {
            return Fail(error: DataSourceError.remoteBadURLRequest(url: "\(endpoint.baseUrl)\(endpoint.path)"))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                //                throw DataSourceError.remoteBadURLResponse(url: request.url?.absoluteString ?? "")
                guard let httpResponse = response as? HTTPURLResponse,
                      (200 ..< 400).contains(httpResponse.statusCode)
                else {
                    throw DataSourceError.remoteBadURLResponse(url: request.url?.absoluteString ?? "")
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
//            .map { data -> AnyPublisher<T, DataSourceError> in
//                self.decodeResponse(data, ofType: T.self)
//            }
            .mapError { error -> DataSourceError in
                if let dataSourceError = error as? DataSourceError {
                    return dataSourceError
                } else {
                    return DataSourceError.remoteDecodingError
                }
            }
            .eraseToAnyPublisher()
    }
    
    internal func decodeResponse<T: Decodable>(_ data: Data, ofType type: T.Type) -> AnyPublisher<T, DataSourceError> {
        do {
            let decoder = JSONDecoder()
            let object = try decoder.decode(type, from: data)
            return Just(object)
                .setFailureType(to: DataSourceError.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: DataSourceError.remoteDecodingError)
                .eraseToAnyPublisher()
        }
    }
}
