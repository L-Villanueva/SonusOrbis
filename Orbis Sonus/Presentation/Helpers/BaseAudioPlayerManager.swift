//
//  BaseAudioPlayerManager.swift
//  Orbis Sonus
//
//  Created by Codex on 8/5/26.
//

import SwiftUI
import AVFoundation
import Combine
import AVKit

class BaseAudioPlayerManager: ObservableObject {

    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 1

    private var player: AVPlayer?
    private var timeObserver: Any?

    func loadAudio(named fileName: String) {
        guard let dataAsset = NSDataAsset(name: fileName),
              let tempURL = writeToTemporaryFile(data: dataAsset.data, suggestedName: "\(fileName).flac")
        else { return }

        let asset = AVAsset(url: tempURL)
        let item = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: item)

        configurePlatformAudio()
        observeTime()
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
        player?.pause()
        player?.seek(to: .zero)
        isPlaying = false
    }

    func seek(to seconds: Double) {
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        player?.seek(to: time)
    }

    func configurePlatformAudio() {
        // Overridden by platform-specific managers when needed.
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
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
    }
}
