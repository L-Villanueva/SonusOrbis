//
//  VideoPlayer.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 13/3/26.
//
import SwiftUI
import AVKit

struct VideoPlayerFromAssetView: View {
    let assetName: String // p.ej. "video_9"
    @State private var player: AVPlayer?

    var body: some View {
        Group {
            if let player = player {
                VideoPlayer(player: player)
                    .onAppear { player.play() }
                    .onDisappear { player.pause() }
            } else {
                Text("Cargando video…")
            }
        }
        .task {
            await preparePlayer()
        }
    }

    @MainActor
    private func preparePlayer() async {
        guard
            let dataAsset = NSDataAsset(name: assetName),
            let tempURL = writeToTemporaryFile(data: dataAsset.data, suggestedName: "\(assetName).mp4")
        else { return }

        player = AVPlayer(url: tempURL)
    }

    private func writeToTemporaryFile(data: Data, suggestedName: String) -> URL? {
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let fileURL = tempDir.appendingPathComponent(suggestedName)
        do {
            try data.write(to: fileURL, options: .atomic)
            return fileURL
        } catch {
            print("Error escribiendo archivo temporal: \(error)")
            return nil
        }
    }
}
