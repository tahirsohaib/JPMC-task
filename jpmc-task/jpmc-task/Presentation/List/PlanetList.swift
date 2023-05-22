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
            .navigationTitle("star wars planets")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("error"),
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
                    PlanetRow(planet: planet)
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

struct PlanetRow: View {
    let planet: PlanetModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(planet.name)
                .font(.headline)
                .foregroundColor(.black)
            
            Text(
                String(
                    localized: "terrain \(planet.terrain)",
                    comment: "Terrains"
                )
            )
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

struct PlanetList_Previews: PreviewProvider {
    static var previews: some View {
        PlanetList()
    }
}
