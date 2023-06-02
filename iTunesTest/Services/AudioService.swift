//
//  AudioService.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 31.05.2023.
//

import Foundation
import AVFoundation

protocol AudioServiceDelegate: AnyObject {
    func didUpdateProgress(currentProgress: Float)
    func didUpdatePlayingState(isPlaying: Bool)
}

protocol AudioServiceProtocol: AnyObject {
    var isPlaying: Bool { get }

    func playAudio(data: Data)
    func pauseAudio()
    func stopAudio()
}

final class AudioService: AudioServiceProtocol {
    
    private var audioPlayer: AVAudioPlayer?
    private var pausedTime: TimeInterval = 0
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    weak var delegate: AudioServiceDelegate?
    
    private var currentAudioProgress: Float {
        let currentPosition = audioPlayer?.currentTime ?? 0
        let audioDuration = audioPlayer?.duration ?? 0
        
        return Float(currentPosition / audioDuration)
    }
    
    var updateProgressCompletion: ((Float) -> Void)?
    
    func playAudio(data: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.currentTime = pausedTime
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            updatePlayingState(isPlaying: true)
            startUpdatingProgress()
        } catch {
            print("AudioPlayer error: \(error.localizedDescription)")
        }
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
        pausedTime = audioPlayer?.currentTime ?? 0
        updatePlayingState(isPlaying: false)
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        pausedTime = 0
        updatePlayingState(isPlaying: false)
    }
    
    private func updatePlayingState(isPlaying: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.delegate?.didUpdatePlayingState(isPlaying: isPlaying)
        }
    }

    private func startUpdatingProgress() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self else { return }
            while self.audioPlayer != nil && self.audioPlayer?.isPlaying == true {
                DispatchQueue.main.async {
                    let progress = self.currentAudioProgress
                    self.delegate?.didUpdateProgress(currentProgress: progress)
                }
                Thread.sleep(forTimeInterval: 1.0)
            }
        }
    }
}

