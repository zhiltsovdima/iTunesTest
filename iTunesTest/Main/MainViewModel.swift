//
//  MainViewModel.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 30.05.2023.
//

import UIKit

protocol MainViewModelProtocol: AnyObject {
    var music: [SongModel] { get }
    var loadingState: LoadingState { get }
    
    func numberOfRows() -> Int
    func searchTextDidChange(_ name: String, completion: @escaping ((LoadingState) -> Void))
}

// MARK: - MainViewModel

final class MainViewModel {
    
    var music = [SongModel]()

    var loadingState: LoadingState = .idle
    
    private let musicService: MusicServiceProtocol
    
    init(_ musicService: MusicServiceProtocol) {
        self.musicService = musicService
    }
}

// MARK: - MainViewModelProtocol

extension MainViewModel: MainViewModelProtocol {
    
    func searchTextDidChange(_ name: String, completion: @escaping ((LoadingState) -> Void)) {
        guard validateName(name) else {
            loadingState = .idle
            completion(loadingState)
            return
        }
        loadingState = .loading
        completion(loadingState)
        
        fetchMusic(by: name, completion: completion)
    }
    
    func numberOfRows() -> Int {
        return music.count
    }
}

// MARK: - Validation

extension MainViewModel {
    private func validateName(_ name: String) -> Bool {
        return name.count >= 3
    }
}

// MARK: - Fetching and Handling

extension MainViewModel {
    private func fetchMusic(by name: String, completion: @escaping ((LoadingState) -> Void)) {
        musicService.getMusic(by: name) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let songs):
                self.handleSuccess(with: songs, completion: completion)
            case .failure(let netError):
                self.handleFailure(with: netError, completion: completion)
            }
        }
    }
    
    private func handleSuccess(with songs: [SongDataModel], completion: @escaping ((LoadingState) -> Void)) {
        let songModels = songs
            .map { SongModel(
                artistName: $0.artistName ?? "No Name",
                trackName: $0.trackName ?? "No Name",
                artworkUr100: $0.artworkUr100,
                artworkUrl600: $0.artworkUrl600,
                previewURL: $0.previewURL)
        }
        music = songModels
        loadingState = .loaded
        completion(loadingState)
    }

    private func handleFailure(with error: NetworkError, completion: @escaping ((LoadingState) -> Void)) {
        loadingState = .failed(error.description)
        completion(loadingState)
    }
}
