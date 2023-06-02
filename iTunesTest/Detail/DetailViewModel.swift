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

    func fetchImage(completion: @escaping ((LoadingState) -> Void))
    func playButtonTapped()
    func backButtonTapped()
    func viewDidDisappear()
}

final class DetailViewModel {
    
    let songModel: SongModel
        
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
    
    private func play() {
        guard let audio = songModel.audio else { return }
        audioService.playAudio(data: audio)
    }
    
    private func pause() {
        audioService.pauseAudio()
    }
    
    private func stop() {
        audioService.stopAudio()
    }
}

// MARK: - DetailViewModelProtocol

extension DetailViewModel: DetailViewModelProtocol {
    
    func fetchImage(completion: @escaping ((LoadingState) -> Void)) {        
        completion(.loading)
        songModel.fetchImage(useMaxSize: true) {
            completion(.loaded)
        }
    }
    
    func playButtonTapped() {
        songModel.fetchAudio { [weak self] in
            guard let self else { return }
            self.audioService.isPlaying ? self.pause() : self.play()
        }
    }
    
    func backButtonTapped() {
        coordinator?.backToMain()
    }
    
    func viewDidDisappear() {
        audioService.stopAudio()
    }
}
