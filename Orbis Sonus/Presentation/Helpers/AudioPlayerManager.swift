//
//  AudioPlayerManager.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 6/4/26.
//

import SwiftUI
import AVFoundation
import Combine
import AVKit

final class AudioPlayerManager: ObservableObject {

    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 1
    @Published var currentTrackName: String?
    @Published var currentRegistroName: String?

    var hasActiveTrack: Bool {
        currentTrackName != nil
    }

    private var player: AVPlayer?
    private var timeObserver: Any?

    func loadAndPlay(trackName: String, registroName: String) {
        removeTimeObserver()
        player?.pause()
        player = nil

        guard let dataAsset = NSDataAsset(name: trackName),
              let tempURL = writeToTemporaryFile(data: dataAsset.data, suggestedName: "\(trackName).flac")
        else { return }

        let asset = AVAsset(url: tempURL)
        let item = AVPlayerItem(asset: asset)

        player = AVPlayer(playerItem: item)
        currentTrackName = trackName
        currentRegistroName = registroName
        currentTime = 0
        duration = 1

        configureAudioSession()
        observeTime()
        play()
    }

    func play() {
        player?.play()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func stop() {
        clear()
    }

    func seek(to seconds: Double) {
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        player?.seek(to: time)
    }

    func clear() {
        removeTimeObserver()
        player?.pause()
        player?.seek(to: .zero)
        player = nil
        isPlaying = false
        currentTime = 0
        duration = 1
        currentTrackName = nil
        currentRegistroName = nil
    }

    private func observeTime() {
        guard let player else { return }

        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            self?.currentTime = time.seconds

            if let duration = player.currentItem?.duration.seconds,
               duration.isFinite {
                self?.duration = duration
            }
        }
    }

    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }

    private func configureAudioSession() {
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
    }

    private func writeToTemporaryFile(data: Data, suggestedName: String) -> URL? {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(suggestedName)
        if FileManager.default.fileExists(atPath: tempURL.path) {
            do {
                try FileManager.default.removeItem(at: tempURL)
            } catch {
                print("Failed to remove existing temp file: \(error)")
                return nil
            }
        }
        do {
            try data.write(to: tempURL, options: .atomic)
            return tempURL
        } catch {
            print("Failed to write temp file: \(error)")
            return nil
        }
    }

    deinit {
        removeTimeObserver()
    }
}
