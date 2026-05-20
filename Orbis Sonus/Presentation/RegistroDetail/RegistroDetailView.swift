//
//  RegistroDetailView.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 14/4/26.
//

import SwiftUI
import MapKit
import AVKit

struct RegistroDetailView: View {
    let registro: Registro
    
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                headerSection
                
                infoSection
                
                if let imageName = registro.image, !imageName.isEmpty {
                    imageSection(imageName: imageName)
                }
                
                if !registro.audio.isEmpty {
                    mediaCard(
                        title: "Audio",
                        icon: "waveform"
                    ) {
                        AudioPlayerRow(audioName: registro.audio[0])
                    }
                }
                
                if let videoName = registro.video, !videoName.isEmpty {
                    mediaCard(
                        title: "Vídeo",
                        icon: "play.rectangle.fill"
                    ) {
                        VideoPlayerView(videoName: videoName)
                            .frame(height: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
                
                if let location = registro.location {
                    locationSection(location: location)
                }
            }
            .padding(16)
        }
        .background(
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.secondarySystemBackground)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let location = registro.location {
                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: location,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                )
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(registro.name)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            
            HStack(spacing: 10) {
                if let date = registro.date, !date.isEmpty {
                    labelChip(text: date, systemImage: "calendar")
                }
                
                if let time = registro.time, !time.isEmpty {
                    labelChip(text: time, systemImage: "clock")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 14, y: 6)
    }
    
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Información")
                .font(.title3.weight(.semibold))
            
            VStack(spacing: 14) {
                detailRow(
                    title: "Nombre",
                    value: registro.name,
                    icon: "textformat"
                )
                
                if let date = registro.date, !date.isEmpty {
                    detailRow(
                        title: "Fecha",
                        value: date,
                        icon: "calendar"
                    )
                }
                
                if let time = registro.time, !time.isEmpty {
                    detailRow(
                        title: "Hora",
                        value: time,
                        icon: "clock"
                    )
                }
                
                detailRow(
                    title: "Audio",
                    value: registro.audio[0],
                    icon: "waveform"
                )
            }
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
    
    private func imageSection(imageName: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Imagen")
                .font(.title3.weight(.semibold))
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 240)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
    
    private func locationSection(location: CLLocationCoordinate2D) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ubicación")
                .font(.title3.weight(.semibold))
            
            Map(position: $cameraPosition) {
                Marker(registro.name, coordinate: location)
            }
            .mapStyle(.hybrid)
            .frame(height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            
            Text("Lat: \(location.latitude.formatted(.number.precision(.fractionLength(5)))) · Lon: \(location.longitude.formatted(.number.precision(.fractionLength(5))))")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
    
    private func mediaCard<Content: View>(
        title: String,
        icon: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.title3.weight(.semibold))
            
            content()
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
    
    private func detailRow(title: String, value: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(.blue)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.body)
                    .foregroundStyle(.primary)
            }
            
            Spacer()
        }
    }
    
    private func labelChip(text: String, systemImage: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: systemImage)
            Text(text)
        }
        .font(.subheadline.weight(.medium))
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.tertiarySystemBackground))
        .clipShape(Capsule())
    }
}

struct AudioPlayerRow: View {
    let audioName: String
    
    var body: some View {
        
        HStack(spacing: 12) {
            AudioPlayerView(audio: audioName)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct VideoPlayerView: View {
    let url: URL?
    init(videoName: String) {
        if let dataAsset = NSDataAsset(name: videoName) {
            self.url = VideoPlayerView.writeToTemporaryFile(data: dataAsset.data, suggestedName: "\(videoName).mp4")
        } else {
            self.url = nil
        }
    }
    var body: some View {
        if let url = url {
            VideoPlayer(player: AVPlayer(url: url))
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.tertiarySystemBackground))
                
                VStack(spacing: 8) {
                    Image(systemName: "video.slash")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("No se encontró el vídeo")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    private static func writeToTemporaryFile(data: Data, suggestedName: String) -> URL? {
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
