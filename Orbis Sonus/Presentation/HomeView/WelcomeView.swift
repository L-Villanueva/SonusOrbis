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
    @State private var currentPage: WelcomePage = .intro

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
                    Group {
                        switch currentPage {
                        case .intro:
                            firstPageContent
                        case .details:
                            secondPageContent
                        }
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 32)
                }

                Button {
                    handlePrimaryButtonTap()
                } label: {
                    Text(currentPage.primaryButtonTitle)
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
        .animation(.easeInOut, value: currentPage)
        .onAppear {
            welcomeAudioPlayer.play()
        }
        .onDisappear {
            welcomeAudioPlayer.stop()
        }
    }

    private var firstPageContent: some View {
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
    }

    private var secondPageContent: some View {
        VStack(alignment: .leading, spacing: 28) {
            Image(.navigationLogo)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 220)
                .padding(.top, 44)

            VStack(alignment: .leading, spacing: 14) {
                Text("Categorías sonoras")
                    .font(.largeTitle.weight(.semibold))
                    .foregroundStyle(.primary)

                Text("Antes de entrar al mapa, estas son las categorías que encontrarás en los registros de la laguna.")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(alignment: .leading, spacing: 18) {
                CategoryInfoRow(
                    type: .motor,
                    description: "Registros asociados al sonido de motores de embarcaciones u otra maquinaria utilizada dentro o alrededor de la laguna. Forma parte de la antropofonía y refleja el tránsito fluvial en la zona."
                )

                CategoryInfoRow(
                    type: .antropico,
                    description: "Sonidos generados por la presencia y actividad humana en el entorno de la laguna, como voces, actividad pesquera o presencia de embarcaciones detenidas. Representa la huella del ser humano dentro del paisaje sonoro."
                )

                CategoryInfoRow(
                    type: .naturaleza,
                    description: "Sonidos propios del entorno natural no asociados a especies específicas, como el viento, el oleaje, las corrientes de agua o el movimiento de la vegetación. Corresponde a la geofonía del ecosistema."
                )

                CategoryInfoRow(
                    type: .atarraya,
                    description: "Registros vinculados específicamente a la actividad de pesca con atarraya (red de lanzamiento manual), una técnica tradicional practicada en la laguna. Se distingue del resto de la actividad antrópica por representar una práctica pesquera puntual."
                )

                CategoryInfoRow(
                    type: .playa,
                    description: "Paisajes sonoros propios de las zonas costeras y litorales de la laguna, donde se combinan el sonido del oleaje, el viento y, en algunos casos, actividad humana cercana a la orilla."
                )

                CategoryInfoRow(
                    type: .aves,
                    description: "Registros de cantos, llamadas y presencia de aves acuáticas y migratorias observadas en distintos sectores del parque. Representa la biofonía del ecosistema y sirve como indicador de la salud del entorno natural."
                )
            }
            .padding(.top, 4)
        }
    }

    private func handlePrimaryButtonTap() {
        switch currentPage {
        case .intro:
            currentPage = .details
        case .details:
            welcomeAudioPlayer.stop()
            onStart()
        }
    }
}

private enum WelcomePage {
    case intro
    case details

    var primaryButtonTitle: String {
        switch self {
        case .intro:
            "Continuar"
        case .details:
            "Empezar"
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

private struct CategoryInfoRow: View {
    let type: RegistroType
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            if let icon = type.icon {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(type.rawValue.capitalized)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    WelcomeView {}
}
