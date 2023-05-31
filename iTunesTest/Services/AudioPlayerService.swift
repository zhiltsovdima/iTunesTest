//
//  AudioPlayerService.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 31.05.2023.
//

import Foundation
import AVFoundation

protocol AudioServiceProtocol {
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
    
    func playAudio(data: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.currentTime = pausedTime
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
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
}

