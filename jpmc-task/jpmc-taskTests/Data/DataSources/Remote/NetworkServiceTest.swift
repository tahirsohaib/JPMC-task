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
        Resolver.main.removeDependencies()
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
    
    func testGetSuccess() {
        // Given
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
        
        // When
        let publisher = networkService.get(PlanetRemoteEntity.self, endpoint: PlanetsEndpoint.allPlanets)
        
        // Then
        let receivedPlanet = try? TestHelpers.waitForPublisher(publisher, expectation: #function)
        
        XCTAssertEqual(receivedPlanet?.name, "Tatooine")
        XCTAssertEqual(receivedPlanet?.terrain, "desert")
        XCTAssertEqual(receivedPlanet?.population, "200000")
    }
    
    func testGetFailure() {
        // Given
        let mockResponse = HTTPURLResponse(url: URL(string: "https://swapi.dev/planets")!, statusCode: 400, httpVersion: "HTTP/1.1", headerFields: nil)!
        
        MockURLProtocol.requestHandler = { request in
            return (mockResponse, Data())
        }
        
        let networkService = NetworkService(urlSession: mockSession)
        let expectedError = APIError.badURLResponse(url: "https://swapi.dev/api/planets")
        
        // When
        let publisher = networkService.get(PlanetRemoteEntity.self, endpoint: PlanetsEndpoint.allPlanets)
        
        // Then
        do {
            _ = try TestHelpers.waitForPublisher(publisher, expectation: #function)
            XCTFail("Publisher should have finished with an error")
        } catch {
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
    }
    
    func testDecodeResponseSuccess () {
        // Given
        let json = """
                {
                    "name": "Earth",
                    "population": "7.9 billion",
                    "terrain": "desert"
                }
            """
        let data = Data(json.utf8)
        let publisher = NetworkService().decodeResponse(data, ofType: PlanetRemoteEntity.self)
        
        // Then
        let receivedPlanet = try? TestHelpers.waitForPublisher(publisher, expectation: #function)
        
        XCTAssertEqual(receivedPlanet, PlanetRemoteEntity.mockPlanetRemoteEntity)
    }
    
    func testDecodeResponseFailure() {
        // Given
        let invalidJson = """
            {
                "name": "Tatooine",
                "terrain": "desert",
            }
        """
        let data = Data(invalidJson.utf8)
        let expectedError = APIError.decodingError
        
        // When
        let publisher = NetworkService().decodeResponse(data, ofType: PlanetRemoteEntity.self)
        
        // Then
        do {
            _ = try TestHelpers.waitForPublisher(publisher, expectation: #function)
            XCTFail("Publisher should have finished with an error")
        } catch {
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
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
