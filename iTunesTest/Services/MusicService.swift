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
    private var searchTask: DispatchWorkItem?
    
    init(_ networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func getMusic(by name: String, completion: @escaping (Result<[SongDataModel], NetworkError>) -> Void) {
        searchTask?.cancel()
        let newSearchTask = DispatchWorkItem { [weak self] in
            guard let self else { return }
            self.performSearch(by: name, completion: completion)
        }
        searchTask = newSearchTask
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: newSearchTask)
    }

    private func performSearch(
        by name: String,
        completion: @escaping (Result<[SongDataModel], NetworkError>) -> Void
    ) {
        networkManager.fetchData(requestType: .songs(name)) { (result: Result<ResultsDataModel, NetworkError>) in
            switch result {
            case .success(let resultsData):
                let music = resultsData.results
                completion(.success(music))
            case .failure(let netError):
                completion(.failure(netError))
            }
        }
    }
}

