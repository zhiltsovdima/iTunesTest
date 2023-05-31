//
//  DetailViewModel.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 31.05.2023.
//

import UIKit
import AVFoundation

protocol DetailViewModelProtocol: AnyObject {
    var songModel: SongModel { get }
    var isPlaying: Bool { get }
    var updateButtonCompletion: (() -> Void)? { get set }

    func fetchImage(completion: @escaping ((LoadingState) -> Void))
    func playButtonTapped()
}

final class DetailViewModel {
    
    let songModel: SongModel
    var updateButtonCompletion: (() -> Void)?
    
    var isPlaying = false {
        didSet {
            updateButtonCompletion?()
        }
    }
        
    private weak var coordinator: AppCoordinatorProtocol?
    private let musicService: MusicServiceProtocol
    private let audioService: AudioServiceProtocol
    
    init(_ coordinator: AppCoordinatorProtocol,
         _ musicService: MusicServiceProtocol,
         _ audioService: AudioServiceProtocol,
         _ songModel: SongModel
    ) {
        self.coordinator = coordinator
        self.musicService = musicService
        self.audioService = audioService
        self.songModel = songModel
    }
}

extension DetailViewModel: DetailViewModelProtocol {
    
    func fetchImage(completion: @escaping ((LoadingState) -> Void)) {        
        completion(.loading)
        songModel.fetchImage(useMaxSize: true) {
            completion(.loaded)
        }
    }
    
    func playButtonTapped() {
        guard let audioUrl = songModel.previewUrl else { return }
        musicService.getTrackPreview(byUrl: audioUrl) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let audio):
                self.songModel.audio = audio
                if self.audioService.isPlaying {
                    self.audioService.pauseAudio()
                } else {
                    self.audioService.playAudio(data: audio)
                }
                self.isPlaying = self.audioService.isPlaying
            case .failure(let netError):
                self.isPlaying = false
                print(netError.description)
            }
        }
    }
    
}
