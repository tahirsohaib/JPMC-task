//
//  PlanetList.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import SwiftUI

struct PlanetList: View {
    @StateObject var viewModel = PlanetListViewModel(getAllPlanetsUseCase: GetAllPlanetsUC(planetRepo: StawWarsRepository(
        remoteDataSource: RemoteDataSource(remoteService: RemotePlanetsService(networkService: NetworkService())),
        localDataSource: LocalDataSource(dbService: CoreDataService())
    )))

    var body: some View {
        List(viewModel.planets, id: \.self) { planet in
            Text(planet.name)
        }
        .onAppear {
            viewModel.syncRemoteAndLocal()
        }
    }
}

struct PlanetList_Previews: PreviewProvider {
    static var previews: some View {
        PlanetList()
    }
}
