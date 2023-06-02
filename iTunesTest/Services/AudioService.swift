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

final class AudioService: NSObject {
    
    private var audioPlayer: AVAudioPlayer?
    weak var delegate: AudioServiceDelegate?
    
    private var pausedTime: TimeInterval = 0
    private var timer: Timer?
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    private var currentAudioProgress: Float {
        guard let currentPosition = audioPlayer?.currentTime,
              let audioDuration = audioPlayer?.duration
        else {
            return 0
        }
        return Float(currentPosition / audioDuration)
    }
}

// MARK: - AudioServiceProtocol

extension AudioService: AudioServiceProtocol {
        
    func playAudio(data: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.delegate = self
            audioPlayer?.currentTime = pausedTime
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            updatePlayingState(isPlaying)
            startUpdatingProgress()
        } catch {
            print("AudioPlayer error: \(error.localizedDescription)")
        }
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
        pausedTime = audioPlayer?.currentTime ?? 0
        updatePlayingState(isPlaying)
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        pausedTime = 0
        updatePlayingState(isPlaying)
        updatePlayingProgress()
    }
}

// MARK: - Private methods

extension AudioService {
    
    private func updatePlayingState(_ isPlaying: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.delegate?.didUpdatePlayingState(isPlaying: isPlaying)
        }
    }
    
    private func updatePlayingProgress() {
        let progress = currentAudioProgress
        DispatchQueue.main.async { [weak self ] in
            guard let self else { return }
            self.delegate?.didUpdateProgress(currentProgress: progress)
        }
    }

    private func startUpdatingProgress() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self else { return }
            while self.audioPlayer != nil && self.audioPlayer?.isPlaying == true {
                self.updatePlayingProgress()
                Thread.sleep(forTimeInterval: 1.0)
            }
        }
    }
}

// MARK: - AVAudioPlayerDelegate

extension AudioService: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            stopAudio()
        }
    }
}
