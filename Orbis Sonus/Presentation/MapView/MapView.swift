//
//  MapView.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 11/3/26.
//
import SwiftUI
import MapKit

struct MapView: View {
    
    @Binding var registros: [Registro]
    @Binding var mapStyleSatellite: Bool
    @EnvironmentObject private var audioPlayerManager: AudioPlayerManager
    @State private var selectedPlace: Registro?
        
    var body: some View {
        ZStack {
            ClusteredMapUIKitView(
                registros: $registros,
                selectedPlace: $selectedPlace,
                mapStyleSatellite: $mapStyleSatellite,
            )
            .edgesIgnoringSafeArea(.all)
        }
        .sheet(item: $selectedPlace) { selectedPlace in
            RegistroDetailView(registro: selectedPlace)
                .environmentObject(audioPlayerManager)
        }
    }
    
    private func detailAction(_ place: Registro) {
        if selectedPlace?.id == place.id {
            withAnimation {
                selectedPlace = nil
            }
        } else {
            withAnimation {
                selectedPlace = place
            }
        }
    }
}

#Preview {
    MapView(registros: .constant([Registro(name: "registro",
                                           sources: "",
                                           audio: ["ANTROPICO_Y_AVES_audio"],
                                           location: .init(latitude: 10.29778, longitude: -65.87639),
                                           time: "10",
                                           image: "image_3",
                                           video: "",
                                           date: "",
                                           type: .antropico)]),
            mapStyleSatellite: .constant(false))
}

