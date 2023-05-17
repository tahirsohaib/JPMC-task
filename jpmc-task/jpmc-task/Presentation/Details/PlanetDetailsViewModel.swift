//
//  PlanetDetailsViewModel.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 17/05/2023.
//

import Foundation
import Combine

class PlanetDetailsViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var films: [FilmModel] = []
    @Published var residents: [ResidentModel] = []
    
    @Injected private var getFilmUC: GetFilmUseCaseProtocol
    @Injected private var getResidentUC: GetResidentUseCaseProtocol

    func getFilms(planet: PlanetModel) {
        let filmPublishers = planet.filmIDs.map { filmURL in
            getFilmUC.execute(filmID: filmURL)
            //FIXME: handle replaceError
                .replaceError(with: FilmModel(title: "Error replacement"))
                .eraseToAnyPublisher()
        }
        
        Publishers.MergeMany(filmPublishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] films in
                self?.films = films
            }
            .store(in: &cancellables)
    }
    
    func getResidents(planet: PlanetModel) {
        let residentPublishers = planet.residentIDs.map { residentId in
            getResidentUC.execute(residentID: residentId)
            //FIXME: handle replaceError
                .replaceError(with: ResidentModel(name: "Error replacement"))
                .eraseToAnyPublisher()
        }
        
        Publishers.MergeMany(residentPublishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] residents in
                self?.residents = residents
            }
            .store(in: &cancellables)
    }
    
}

