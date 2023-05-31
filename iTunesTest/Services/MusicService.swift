//
//  MusicService.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 30.05.2023.
//

import UIKit

protocol MusicServiceProtocol {
    func getMusic(by name: String, completion: @escaping (Result<[SongDataModel], NetworkError>) -> Void)
    func getImage(byUrl urlString: String?, completion: @escaping ((Result<UIImage, NetworkError>) -> Void))
    func getTrackPreview(byUrl urlString: String?, completion: @escaping ((Result<Data, NetworkError>) -> Void))
}

final class MusicService {
    
    private let networkManager: NetworkManagerProtocol
    private var searchTask: DispatchWorkItem?
    
    private var imageCache = NSCache<NSURL, UIImage>()
    
    
    init(_ networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

// MARK: - MusicServiceProtocol

extension MusicService: MusicServiceProtocol {
        
    func getMusic(by name: String, completion: @escaping (Result<[SongDataModel], NetworkError>) -> Void) {
        searchTask?.cancel()
        let newSearchTask = DispatchWorkItem { [weak self] in
            guard let self else { return }
            self.performSearch(by: name, completion: completion)
        }
        searchTask = newSearchTask
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: newSearchTask)
    }
    
    func getImage(byUrl urlString: String?, completion: @escaping ((Result<UIImage, NetworkError>) -> Void)) {
        guard let urlString, let imageURL = URL(string: urlString) else {
            completion(.failure(NetworkError.wrongURL))
            return
        }
        if let cachedImage = imageCache.object(forKey: imageURL as NSURL) {
            completion(.success(cachedImage))
            return
        }
        networkManager.fetchData(from: imageURL) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let imageData):
                self.processImageData(imageData, imageURL: imageURL, completion: completion)
            case .failure(let netError):
                completion(.failure(netError))
            }
        }
    }
    
    func getTrackPreview(byUrl urlString: String?, completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        guard let urlString,
              let audioURL = URL(string: urlString)
        else {
            completion(.failure(NetworkError.wrongURL))
            return
        }
        networkManager.fetchData(from: audioURL) { result in
            switch result {
            case .success(let audioData):
                completion(.success(audioData))
            case .failure(let netError):
                completion(.failure(netError))
            }
        }
    }
    
}

// MARK: - Private Methods

extension MusicService {
    
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
    
    private func processImageData(_ data: Data, imageURL: URL, completion: @escaping ((Result<UIImage, NetworkError>) -> Void)) {
        guard let image = UIImage(data: data) else {
            completion(.failure(NetworkError.unableToDecode))
            return
        }
        imageCache.setObject(image, forKey: imageURL as NSURL)
        completion(.success(image))
    }
    
}

