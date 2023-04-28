//
//  jpmc_taskApp.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import SwiftUI

@main
struct jpmc_taskApp: App {
    
    @StateObject private var viewModel = PlanetListViewModel()
    
    init() {
        Resolver.main.register(type: CoreDataServiceProtocol.self, service: CoreDataStorage(.persistent))
        Resolver.main.register(type: CoreDataServiceProtocol.self, service: CoreDataStorage())
        Resolver.main.register(type: LocalDataSourceProtocol.self, service: LocalDataSource())
        Resolver.main.register(type: NetworkServiceProtocol.self, service: NetworkService())
        Resolver.main.register(type: RemotePlanetsServiceProtocol.self, service: RemotePlanetsService())
        Resolver.main.register(type: RemoteDataSourceProtocol.self, service: RemoteDataSource())
        Resolver.main.register(type: PlanetsRepositoryProtocol.self, service: StarWarsRepository())
        Resolver.main.register(type: GetAllPlanetsUseCaseProtocol.self, service: GetAllPlanetsUC())
    }    
    
    var body: some Scene {
        WindowGroup {
            PlanetList()
                .environmentObject(viewModel)
                .onAppear {
                    viewModel.syncRemoteAndLocal()
                }
        }
    }
}
