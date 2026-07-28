//
//  WelcomeView.swift
//  Orbis Sonus
//
//  Created by Codex on 19/7/26.
//

import SwiftUI
import AVFoundation
import Combine

struct WelcomeView: View {
    @StateObject private var welcomeAudioPlayer = WelcomeAudioPlayer(assetName: "NAT_8_audio")

    let onStart: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.94, green: 0.98, blue: 0.96),
                    Color(red: 0.82, green: 0.91, blue: 0.92),
                    Color(red: 0.98, green: 0.96, blue: 0.90)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        Image(.navigationLogo)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 220)
                            .padding(.top, 44)

                        VStack(alignment: .leading, spacing: 14) {
                            Text("Bienvenido a Orbis Sonus")
                                .font(.largeTitle.weight(.semibold))
                                .foregroundStyle(.primary)

                            Text("Explora el mapa sonoro de la Laguna de Tacarigua y descubre registros de audio, imágenes e información del proyecto.")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        VStack(alignment: .leading, spacing: 18) {
                            InstructionRow(
                                iconName: "map",
                                title: "Navega el mapa",
                                description: "Muévete por el mapa y toca los puntos para ver los registros disponibles en cada zona."
                            )

                            InstructionRow(
                                iconName: "speaker.wave.2",
                                title: "Escucha los sonidos",
                                description: "Abre un registro para reproducir sus audios y controlar la reproducción desde la barra inferior."
                            )

                            InstructionRow(
                                iconName: "line.3.horizontal.decrease.circle",
                                title: "Filtra y explora",
                                description: "Usa los filtros, la lista y la galería para encontrar registros por tipo o revisar el contenido visual."
                            )
                        }
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 32)
                }

                Button {
                    welcomeAudioPlayer.stop()
                    onStart()
                } label: {
                    Text("Empezar")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.regular)
                .padding(.horizontal, 28)
                .padding(.top, 12)
                .padding(.bottom, 14)
                .background(.ultraThinMaterial)
            }
        }
        .onAppear {
            welcomeAudioPlayer.play()
        }
        .onDisappear {
            welcomeAudioPlayer.stop()
        }
    }
}

private final class WelcomeAudioPlayer: ObservableObject {
    private let assetName: String
    private var player: AVAudioPlayer?

    init(assetName: String) {
        self.assetName = assetName
    }

    func play() {
        guard player == nil else {
            player?.play()
            return
        }

        guard let dataAsset = NSDataAsset(name: assetName) else {
            print("Welcome audio asset not found: \(assetName)")
            return
        }

        do {
            let audioPlayer = try AVAudioPlayer(data: dataAsset.data)
            audioPlayer.numberOfLoops = -1
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            player = audioPlayer
        } catch {
            print("Welcome audio error: \(error)")
        }
    }

    func stop() {
        player?.stop()
        player?.currentTime = 0
        player = nil
    }
}

private struct InstructionRow: View {
    let iconName: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    WelcomeView {}
}
