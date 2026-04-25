//
//  AudioPlayerView.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 6/4/26.
//
import SwiftUI

struct AudioPlayerView: View {

    @StateObject private var audioPlayer = AudioPlayerManager()
    var audio: String

    var body: some View {
        VStack(spacing: 20) {
            Slider(
                value: $audioPlayer.currentTime,
                in: 0...audioPlayer.duration,
                onEditingChanged: { editing in
                    if !editing {
                        audioPlayer.seek(to: audioPlayer.currentTime)
                    }
                }
            )

            HStack {
                Button("Play") {
                    audioPlayer.play()
                }

                Button("Pause") {
                    audioPlayer.pause()
                }

                Button("Stop") {
                    audioPlayer.stop()
                }
            }
        }
        .padding()
        .onAppear {
            audioPlayer.loadAudio(named: audio)
        }
    }
}
