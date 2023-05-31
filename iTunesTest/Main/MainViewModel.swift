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
    func fetchImage(for index: IndexPath, completion: @escaping (IndexPath) -> Void)
    func selectRow(at index: IndexPath)
}

// MARK: - MainViewModel

final class MainViewModel {
    
    var music = [SongModel]()
    var loadingState: LoadingState = .idle
    
    private weak var coordinator: AppCoordinatorProtocol?
    private let musicService: MusicServiceProtocol
    
    init(_ coordinator: AppCoordinatorProtocol, _ musicService: MusicServiceProtocol) {
        self.musicService = musicService
        self.coordinator = coordinator
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
    
    func fetchImage(for index: IndexPath, completion: @escaping (IndexPath) -> Void) {
        let model = music[index.row]
        model.fetchImage(useMaxSize: false) {
            completion(index)
        }
    }
    
    func numberOfRows() -> Int {
        return music.count
    }
    
    func selectRow(at index: IndexPath) {
        let songModel = music[index.row]
        coordinator?.showDetail(with: songModel)
    }
}

// MARK: - Validation

extension MainViewModel {
    private func validateName(_ name: String) -> Bool {
        let russianLetters = CharacterSet(charactersIn: "абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ")
        let isRussianLetters = name.rangeOfCharacter(from: russianLetters) != nil
        return name.count >= 3 && !isRussianLetters
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
                musicService,
                artistName: $0.artistName ?? "No Name",
                trackName: $0.trackName ?? "No Name",
                artworkUrl100: $0.artworkUrl100,
                artworkUrl600: $0.artworkUrl600,
                previewUrl: $0.previewUrl)
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
