//
//  BottomNavView.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 12/3/26.
//

import SwiftUI

struct BottomNavView: View {
    
    @State var isShowingFilters: Bool = false
    @Binding var mapStyleSatellite: Bool
    @Binding var filter: RegistroType?
    let showsMapControls: Bool
    
    var filterTypes: [RegistroType] {
        RegistroType.allCases
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                if showsMapControls && isShowingFilters {
                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(filterTypes, id: \.self) { type in
                                Button {
                                    guard filter != type else {
                                        self.filter = nil
                                        return
                                    }
                                    self.filter = type
                                } label: {
                                    HStack(alignment: .center) {
                                        Image(systemName: type == filter ? "checkmark.square.fill" : "square")
                                            .foregroundColor(type == filter ? .blue : .secondary)
                                        Text(type.rawValue.capitalized)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 26)
                        .glassModifier()
                        .clipShape(UnevenRoundedRectangle(cornerRadii:
                                                            RectangleCornerRadii(topLeading: 20,
                                                                                 topTrailing: 20)))
                        Spacer()
                    }
                }

                HStack {
                    BottomNavContent(isShowingFilters: $isShowingFilters,
                                     stateButton: $mapStyleSatellite,
                                     showsMapControls: showsMapControls)
                    
                }
                .frame(height: 60)
                .padding(.horizontal, 20)
                .glassModifier()

                .clipShape(
                    isShowingFilters
                    ? UnevenRoundedRectangle(cornerRadii:
                                                RectangleCornerRadii(bottomLeading: 20,
                                                                     bottomTrailing: 20,
                                                                     topTrailing: 20))
                    : UnevenRoundedRectangle(cornerRadii:
                                                RectangleCornerRadii(topLeading: 20,
                                                                     bottomLeading: 20,
                                                                     bottomTrailing: 20,
                                                                     topTrailing: 20)))
                

            }
            .padding(.vertical, showsMapControls ? 40 : 0)
            .padding(.horizontal, 20)
            .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 2)
            .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 8)
        }
        .animation(.easeInOut, value: isShowingFilters)
    }
}

struct BottomNavContent: View {
    @EnvironmentObject private var audioPlayerManager: AudioPlayerManager

    @Binding var isShowingFilters: Bool
    @Binding var stateButton: Bool
    let showsMapControls: Bool
    // change the action in these buttons based on your desired behavior
    var body: some View {
        HStack(spacing: 8) {
            if showsMapControls {
                Button("", systemImage: isShowingFilters ? "eye.fill" : "eye") {
                    isShowingFilters.toggle()
                }
                Button("", systemImage: stateButton ? "map.fill" : "map") {
                    stateButton.toggle()
                }
            }
            
            Spacer()
            if audioPlayerManager.hasActiveTrack {
                audioPlayerSection
            }
        }
    }
    
    private var audioPlayerSection: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {

                Button {
                    if audioPlayerManager.isPlaying {
                        audioPlayerManager.pause()
                    } else {
                        audioPlayerManager.play()
                    }
                } label: {
                    Image(systemName: audioPlayerManager.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title3)
                }
                
                Slider(
                    value: $audioPlayerManager.currentTime,
                    in: 0...audioPlayerManager.duration,
                    onEditingChanged: { editing in
                        if !editing {
                            audioPlayerManager.seek(to: audioPlayerManager.currentTime)
                        }
                    }
                )

                Button {
                    audioPlayerManager.stop()
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.title3)
                }
            }
        }
        .animation(.easeInOut, value: audioPlayerManager.hasActiveTrack)
    }
}
