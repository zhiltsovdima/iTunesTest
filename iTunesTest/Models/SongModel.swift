//
//  SongModel.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 30.05.2023.
//

import UIKit

final class SongModel {
    let artist, track: String
    let imageUrl100, imageUrl600: String?
    let previewUrl: String?
    
    var imageMin: UIImage?
    var imageMax: UIImage?
    
    var audio: Data?
    
    private var isImageMaxLoaded = false
    private var isImageMinLoaded = false
    
    private let musicService: MusicServiceProtocol
    
    init(_ musicService: MusicServiceProtocol,
         artistName: String,
         trackName: String,
         artworkUrl100: String?,
         artworkUrl600: String?,
         previewUrl: String?
    ) {
        self.musicService = musicService
        self.artist = artistName
        self.track = trackName
        self.imageUrl100 = artworkUrl100
        self.imageUrl600 = artworkUrl600
        self.previewUrl = previewUrl
    }
    
    func fetchImage(useMaxSize: Bool, completion: @escaping (() -> Void)) {
        let isLoaded = useMaxSize ? isImageMaxLoaded : isImageMinLoaded
    
        guard !isLoaded else {
            completion()
            return
        }
        
        let urlString = useMaxSize ? imageUrl600 ?? imageUrl100 : imageUrl100
        
        musicService.getImage(byUrl: urlString) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let image):
                self.updateImage(useMaxSize: useMaxSize, with: image)
            case .failure(let netError):
                self.imageFetchingFailure(useMaxSize: useMaxSize, netError: netError)
            }
            completion()
        }
    }
    
    private func updateImage(useMaxSize: Bool, with image: UIImage) {
        if useMaxSize {
            imageMax = image
            isImageMaxLoaded = true
        } else {
            imageMin = image
            isImageMinLoaded = true
        }
    }

    private func imageFetchingFailure(useMaxSize: Bool, netError: NetworkError) {
        let failedImage = Resources.Images.failedImage
        if useMaxSize {
            imageMin = failedImage
            isImageMinLoaded = false
        } else {
            imageMax = failedImage
            isImageMaxLoaded = false
        }
        print("Fetching image failure: \(netError.description)")
    }


}
