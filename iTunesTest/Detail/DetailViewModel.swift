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
}

final class DetailViewModel {
    
    let songModel: SongModel
    
    var audioPlayer = AVAudioPlayer()
    
    private weak var coordinator: AppCoordinatorProtocol?
    private let musicService: MusicServiceProtocol
    
    init(_ coordinator: AppCoordinatorProtocol, _ musicService: MusicServiceProtocol, _ songModel: SongModel) {
        self.coordinator = coordinator
        self.musicService = musicService
        self.songModel = songModel
    }
    
    func playAudio(data: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print("AudioPlayer error: \(error.localizedDescription)")
        }
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
                self.playAudio(data: audio)
            case .failure(let netError):
                print(netError.description)
            }
        }
    }
    
}
