//
//  AudioService.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 31.05.2023.
//

import Foundation
import AVFoundation

protocol AudioServiceProtocol: AnyObject {
    var isPlaying: Bool { get }
    var updateProgressCompletion: ((Float) -> Void)? { get set }

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
    
    var currentPosition: TimeInterval {
        return audioPlayer?.currentTime ?? 0
    }
    
    var audioDuration: TimeInterval {
        return audioPlayer?.duration ?? 0
    }
    
    var updateProgressCompletion: ((Float) -> Void)?
    
    func playAudio(data: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.currentTime = pausedTime
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            startUpdatingProgress()
        } catch {
            print("AudioPlayer error: \(error.localizedDescription)")
        }
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
        pausedTime = audioPlayer?.currentTime ?? 0
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
    }

    private func startUpdatingProgress() {
        DispatchQueue.global(qos: .default).async {
            while self.audioPlayer != nil && self.audioPlayer?.isPlaying == true {
                DispatchQueue.main.async {
                    self.updateProgress()
                }
                Thread.sleep(forTimeInterval: 1.0)
            }
        }
    }
    
    private func updateProgress() {
        let progress = Float(currentPosition / audioDuration)
        updateProgressCompletion?(progress)
    }
}

