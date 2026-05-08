//
//  AudioPlayerManager.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 6/4/26.
//


import AVFoundation
final class AudioPlayerManager: BaseAudioPlayerManager {
    override func configurePlatformAudio() {
        #if os(iOS)
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .moviePlayback,
                options: [.allowAirPlay]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
        #endif
    }
}
#if os(macOS)
typealias PlatformAudioPlayerManager = AudioPlayerManagerMacOS
#else
typealias PlatformAudioPlayerManager = AudioPlayerManager
#endif
final class AudioPlayerManagerMacOS: BaseAudioPlayerManager {}
