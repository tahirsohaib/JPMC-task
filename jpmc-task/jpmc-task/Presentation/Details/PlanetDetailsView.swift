//
//  PlanetDetailsView.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 17/05/2023.
//

import SwiftUI

struct PlanetDetailsView: View {
    @Binding var planet: PlanetModel?
    @StateObject private var viewModel = PlanetDetailsViewModel()
    
    var body: some View {
        List {
            Section(header: Text("planet")) {
                Text(planet!.name)
            }
            
            if !viewModel.films.isEmpty {
                Section(header: Text("films")) {
                    ForEach(viewModel.films, id: \.self) { film in
                        Text(film.title)
                    }
                }
            }
            
            if !viewModel.residents.isEmpty {
                Section(header: Text("residents")) {
                    ForEach(viewModel.residents, id: \.self) { resident in
                        Text(resident.name)
                    }
                }
            }
        }
        .navigationBarTitle("planet details",displayMode: .inline)
        .onAppear {
            viewModel.getFilms(planet: planet!)
            viewModel.getResidents(planet: planet!)
        }
    }
}

struct PlanetDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetDetailsView(planet: .constant(PlanetModel.mockPlanetModel1))
    }
}
