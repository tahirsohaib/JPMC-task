//
//  PlanetList.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import SwiftUI

struct PlanetList: View {
    @StateObject private var viewModel = PlanetListViewModel()
    @State var firstAppear: Bool = true
    @State private var showDetailView: Bool = false
    @State private var selectedPlanet: PlanetModel? = nil
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    listView
                }
            }
            .navigationTitle("Star Wars Planets")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK"), action: {
                        viewModel.dismissAlert()
                    })
                )
            }
        }
        .onAppear {
            if firstAppear {
                viewModel.syncRemoteAndLocal()
                firstAppear = false
            }
        }
    }
}

extension PlanetList {
    private func navigateToDetail(planet: PlanetModel) {
        selectedPlanet = planet
        showDetailView.toggle()
    }
    
    private var listView: some View {
            List(viewModel.planets, id: \.self) { planet in
                Button(action: {
                    navigateToDetail(planet: planet)
                }) {
                    VStack(alignment: .leading) {
                        Text(planet.name)
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("Terrain: \(planet.terrain)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .background(
                NavigationLink(
                    "",
                    isActive: $showDetailView,
                    destination: {
                        PlanetDetailsView(planet: $selectedPlanet)
                    })
            )
        }
}


struct PlanetList_Previews: PreviewProvider {
    static var previews: some View {
        PlanetList()
    }
}
