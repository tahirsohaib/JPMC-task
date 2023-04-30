//
//  NetworkServiceTest.swift
//  jpmc-taskTests
//
//  Created by Sohaib Tahir on 29/04/2023.
//

import XCTest
@testable import jpmc_task
import Combine

class NetworkServiceTest: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    var mockSession: URLSession!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: configuration)
    }
    
    override func tearDown() {
        mockSession.invalidateAndCancel()
        mockSession = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testGet() {
        let mockResponse = HTTPURLResponse(url: URL(string: "https://swapi.dev/planets")!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        
        let mockData = """
                {
                    "name": "Tatooine",
                    "terrain": "desert",
                    "population": "200000"
                }
                """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            return (mockResponse, mockData)
        }
        
        let networkService = NetworkService(urlSession: mockSession)
        let expectation = self.expectation(description: "get function succeeds")
        
        networkService.get(PlanetRemoteEntity.self, endpoint: PlanetsEndpoint.allPlanets)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
            }, receiveValue: { receivedPlanet in
                XCTAssertEqual(receivedPlanet.name, "Tatooine")
                XCTAssertEqual(receivedPlanet.terrain, "desert")
                XCTAssertEqual(receivedPlanet.population, "200000")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.2)
    }
    
        
    func testDecodeResponse() {
        let expectedEntity = PlanetRemoteEntity(name: "Tatooine", terrain: "desert", population: "200000")
        
        let json = """
                {
                    "name": "Tatooine",
                    "terrain": "desert",
                    "population": "200000"
                }
            """
        let data = Data(json.utf8)
        
        // then
        let expectation = self.expectation(description: "Decode response")
        NetworkService().decodeResponse(data, ofType: PlanetRemoteEntity.self)
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Unexpected error: \(error)")
                }
            } receiveValue: { entity in
                XCTAssertEqual(entity, expectedEntity)
            }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.2)
    }
}

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }

        let (response, data) = handler(request)
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
