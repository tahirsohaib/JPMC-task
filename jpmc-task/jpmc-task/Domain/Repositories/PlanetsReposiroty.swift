//
//  PlanetsReposiroty.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Combine
import Foundation

protocol StarWarsRepositoryProtocol {
    func getAllPlanets() -> AnyPublisher<[PlanetModel], DataSourceError>
    func syncLocalPlanetsRepoWithRemote() -> AnyPublisher<[PlanetModel], DataSourceError>
    
    func getFilm(filmID: String) -> AnyPublisher<FilmModel, DataSourceError>
    func getResident(residentID: String) -> AnyPublisher<ResidentModel, DataSourceError>
}
