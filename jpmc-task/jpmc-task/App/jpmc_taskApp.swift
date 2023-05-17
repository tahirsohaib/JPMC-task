//
//  jpmc_taskApp.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import SwiftUI

@main
struct jpmc_taskApp: App {
    
    ///Here we register all the services that are required by our app using the register method of the Resolver. By registering these services with the Resolver, you are telling the container how to create and manage these dependencies.
    init() {
        Resolver.main.register(type: CoreDataServiceProtocol.self, service: CoreDataStorage(.persistent))
        Resolver.main.register(type: CoreDataServiceProtocol.self, service: CoreDataStorage())
        Resolver.main.register(type: LocalDataSourceProtocol.self, service: LocalDataSource())
        Resolver.main.register(type: NetworkServiceProtocol.self, service: NetworkService())
        Resolver.main.register(type: RemotePlanetsServiceProtocol.self, service: RemotePlanetsService())
        Resolver.main.register(type: RemoteFilmsServiceProtocol.self, service: RemoteFilmsService())
        Resolver.main.register(type: RemoteResidentsServiceProtocol.self, service: RemoteResidentsService())
        Resolver.main.register(type: RemoteDataSourceProtocol.self, service: RemoteDataSource())
        Resolver.main.register(type: StarWarsRepositoryProtocol.self, service: StarWarsRepository())
        Resolver.main.register(type: GetAllPlanetsUseCaseProtocol.self, service: GetAllPlanetsUC())
        Resolver.main.register(type: GetFilmUseCaseProtocol.self, service: GetFilmUC())
        Resolver.main.register(type: GetResidentUseCaseProtocol.self, service: GetResidentUC())
    }
    
    var body: some Scene {
        WindowGroup {
            PlanetList()
        }
    }
}
