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
    
    var body: some View {
        NavigationView {
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        List(viewModel.planets, id: \.self) { planet in
                            VStack(alignment: .leading) {
                                Text(planet.name)
                                    .font(.headline)
                                Text("Terrain: \(planet.terrain)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .listStyle(.plain)
                    }
                }                
                .navigationTitle("Star Wars Planets")
            }
        .onAppear {
            if !self.firstAppear { return }
            viewModel.syncRemoteAndLocal()
        }
    }
}

struct PlanetList_Previews: PreviewProvider {
    static var previews: some View {
        PlanetList()
    }
}
