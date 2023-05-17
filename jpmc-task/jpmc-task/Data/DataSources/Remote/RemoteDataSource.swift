//
//  RemoteDataSource.swift
//  jpmc-task
//
//  Created by Sohaib Tahir on 23/04/2023.
//

import Combine
import Foundation

class RemoteDataSource: RemoteDataSourceProtocol {
    @Injected private var remotePlanetService: RemotePlanetsServiceProtocol
    @Injected private var remoteFilmService: RemoteFilmsServiceProtocol
    @Injected private var remoteResidentService: RemoteResidentsServiceProtocol

    private func mapPlanetRemoteToResponse(remoteEntity: PlanetRemoteEntity) -> PlanetModel {
        return PlanetModel(name: remoteEntity.name, population: remoteEntity.population, terrain: remoteEntity.terrain, filmIDs: remoteEntity.filmIDs, residentIDs: remoteEntity.residentIDs, films: nil, residents:nil)
    }
    
    private func mapFilmRemoteToResponse(remoteEntity: FilmRemoteEntity) -> FilmModel {
        return FilmModel(title: remoteEntity.title)
    }
    
    private func mapResidentRemoteToResponse(remoteEntity: ResidentRemoteEntity) -> ResidentModel {
        return ResidentModel(name: remoteEntity.name)
    }

    func getAllPlanetsRemote() -> AnyPublisher<[PlanetModel], DataSourceError> {
        remotePlanetService.fetchPlanets()
            .map { planetRemoteEntities in
                planetRemoteEntities.map { self.mapPlanetRemoteToResponse(remoteEntity: $0) }
            }
            .eraseToAnyPublisher()
    }
    
    func getFilmRemote(filmID: String) -> AnyPublisher<FilmModel, DataSourceError> {
        remoteFilmService.fetchFilms(filmId: filmID)
            .map { filmRemoteEntity in
                self.mapFilmRemoteToResponse(remoteEntity: filmRemoteEntity)
            }
            .eraseToAnyPublisher()
    }
    
    func getResidentRemote(residentID: String) -> AnyPublisher<ResidentModel, DataSourceError> {
        remoteResidentService.fetchResidents(residentId: residentID)
            .map { residentRemoteEntity in
                self.mapResidentRemoteToResponse(remoteEntity: residentRemoteEntity)
            }
            .eraseToAnyPublisher()
    }

}
