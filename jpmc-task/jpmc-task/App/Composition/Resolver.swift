//
//  Resolver.swift
//  Todo Internal
//
//  Created by Sohaib Tahir on 24/04/2023.
//

import Foundation

public final class Resolver {
    
    public static var main: Resolver = Resolver()
    
    private var dependecies: [DependencyKey : Any] = [:]
    
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
