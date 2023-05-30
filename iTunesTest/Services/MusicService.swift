//
//  MusicService.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 30.05.2023.
//

import Foundation

protocol MusicServiceProtocol {
    func getMusic(by name: String, completion: @escaping (Result<[SongDataModel], NetworkError>) -> Void)
}

final class MusicService: MusicServiceProtocol {
    
    private let networkManager: NetworkManagerProtocol
    
    init(_ networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func getMusic(by name: String, completion: @escaping (Result<[SongDataModel], NetworkError>) -> Void) {
        networkManager.fetchData(requestType: .songs(name)) { (result: Result<ResultsDataModel, NetworkError>) in
            switch result {
            case .success(let resultsData):
                let music = resultsData.results
                completion(.success(music))
            case .failure(let netError):
                print(netError.description)
                completion(.failure(netError))
            }
        }
    }
}

