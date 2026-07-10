//
//  VideoPlayer.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 13/3/26.
//
import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let assetName: String // p.ej. "video_9"
    @State private var player: AVPlayer?
    @State private var aspectRatio: CGFloat = 16 / 9
    @State private var isFullscreen = false

    private var isPortrait: Bool { aspectRatio < 1 }
    private let cornerRadius: CGFloat = 18
    private let maxPortraitHeight: CGFloat = 420

    var body: some View {
        Color.clear
            .aspectRatio(aspectRatio, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: isPortrait ? maxPortraitHeight : nil)
            .overlay {
                Group {
                    if let player = player {
                        InlineVideoPlayerRepresentable(player: player)
                            .onDisappear { player.pause() }
                    } else {
                        ProgressView("Cargando video…")
                    }
                }
            }
            .compositingGroup()
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(alignment: .topTrailing) {
                if player != nil {
                    Button {
                        isFullscreen = true
                    } label: {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(.black.opacity(0.55))
                            .clipShape(Circle())
                    }
                    .padding(10)
                    .accessibilityLabel("Pantalla completa")
                }
            }
            .fullScreenCover(isPresented: $isFullscreen) {
                if let player = player {
                    FullscreenVideoPlayer(player: player)
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

        if let ratio = await loadAspectRatio(from: tempURL) {
            aspectRatio = ratio
        }

        let player = AVPlayer(url: tempURL)
        player.isMuted = true
        self.player = player
    }

    private func loadAspectRatio(from url: URL) async -> CGFloat? {
        let asset = AVURLAsset(url: url)
        guard let track = try? await asset.loadTracks(withMediaType: .video).first else { return nil }
        guard
            let naturalSize = try? await track.load(.naturalSize),
            let transform = try? await track.load(.preferredTransform)
        else { return nil }

        let size = naturalSize.applying(transform)
        let width = abs(size.width)
        let height = abs(size.height)
        guard width > 0, height > 0 else { return nil }

        return width / height
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

private struct FullscreenVideoPlayer: View {
    let player: AVPlayer
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            AVPlayerViewControllerRepresentable(player: player)
                .ignoresSafeArea()
        }
        .overlay(alignment: .topTrailing) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .black.opacity(0.45))
            }
            .padding()
            .padding(.vertical, 24)
            .accessibilityLabel("Cerrar pantalla completa")
        }
        .statusBarHidden()
    }
}

private struct InlineVideoPlayerRepresentable: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> PlayerContainerViewController {
        let container = PlayerContainerViewController()
        container.setPlayer(player)
        return container
    }

    func updateUIViewController(_ uiViewController: PlayerContainerViewController, context: Context) {
        uiViewController.setPlayer(player)
    }
}

private final class PlayerContainerViewController: UIViewController {
    private var playerViewController: AVPlayerViewController?

    func setPlayer(_ player: AVPlayer) {
        if let playerViewController {
            playerViewController.player = player
            return
        }

        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        controller.entersFullScreenWhenPlaybackBegins = false
        controller.exitsFullScreenWhenPlaybackEnds = false
        controller.allowsPictureInPicturePlayback = false

        addChild(controller)
        view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        controller.didMove(toParent: self)
        playerViewController = controller
    }
}

private struct AVPlayerViewControllerRepresentable: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        controller.entersFullScreenWhenPlaybackBegins = false
        controller.exitsFullScreenWhenPlaybackEnds = false
        controller.allowsPictureInPicturePlayback = false
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}
