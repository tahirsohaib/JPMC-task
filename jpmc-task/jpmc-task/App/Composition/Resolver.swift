//
//  Resolver.swift
//  Todo Internal
//
//  Created by Sohaib Tahir on 24/04/2023.
//

import Foundation

public final class Resolver {
    ///The Resolver is a simple implementation of a dependency injection container that is used to manage the dependencies in our application. It consists of two main methods: register and resolve. The register method is used to register a service with the container, and the resolve method is used to retrieve the service.
    public static var main: Resolver = Resolver()
    
    private var dependecies: [DependencyKey : Any] = [:]
    
    public func removeDependencies() {
        dependecies.removeAll()
    }
    
    // MARK: - Service Resolution
    
    public func register<Service>(type: Service.Type, name: String? = nil, service: Any) {
            let dependencyKey = DependencyKey(type: type, name: name)
            dependecies[dependencyKey] = service
        }
    
    public func resolve<Service>(_ type: Service.Type = Service.self, name: String? = nil) -> Service {
        let dependencyKey = DependencyKey(type: type, name: name)
        return dependecies[dependencyKey] as! Service
    }
    
    public static func resolve<Service>(_ type: Service.Type = Service.self, name: String? = nil) -> Service {
        let dependencyKey = DependencyKey(type: type, name: name)
        return main.dependecies[dependencyKey] as! Service
    }
}

class DependencyKey: Hashable, Equatable {
    private let type: Any.Type
    private let name: String?

    init(type: Any.Type, name: String? = nil) {
        self.type = type
        self.name = name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
        hasher.combine(name)
    }

    static func == (lhs: DependencyKey, rhs: DependencyKey) -> Bool {
        return lhs.type == rhs.type && lhs.name == rhs.name
    }
}
