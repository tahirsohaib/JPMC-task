//
//  Injected.swift
//  Todo Internal
//
//  Created by Sohaib Tahir on 24/04/2023.
//

import Foundation

///The Injected property wrapper is used to simplify the dependency injection process by automatically injecting the dependencies into a property. When you declare a property with the Injected wrapper, the init() method of the Injected struct is called, and it retrieves the corresponding service from the Resolver. The wrappedValue property is used to retrieve the injected service, and the projectedValue property is used to get a reference to the Injected struct itself.
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
