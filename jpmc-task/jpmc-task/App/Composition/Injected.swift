//
//  Injected.swift
//  Todo Internal
//
//  Created by Sohaib Tahir on 24/04/2023.
//

import Foundation

@propertyWrapper
public struct Injected<Service> {
    private var service: Service
    
    public init() {
        self.service = Resolver.resolve(Service.self)
    }
    
    public init(name: String? = nil, container: Resolver? = nil) {
        self.service = container?.resolve(Service.self, name: name) ?? Resolver.resolve(Service.self, name: name)
    }
    
    public var wrappedValue: Service {
        get { return service }
        mutating set { service = newValue }
    }
    
    public var projectedValue: Injected<Service> {
        get { return self }
        mutating set { self = newValue }
    }
}
