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
    @Binding var opacity: Double
    @Binding var mapStyleSatellite: Bool
    @State private var selectedPlace: Registro?
    @State private var point: CGPoint?
        
    var body: some View {
        ZStack {
            Group {
#if os(macOS)
                ClusteredMapAppKitView(
                    registros: $registros,
                    selectedPlace: $selectedPlace,
                    mapStyleSatellite: $mapStyleSatellite,
                )
#else
                ClusteredMapUIKitView(
                    registros: $registros,
                    selectedPlace: $selectedPlace,
                    mapStyleSatellite: $mapStyleSatellite,
                )
#endif
            }
            .edgesIgnoringSafeArea(.all)
        }
#if os(macOS)
        
        .popover(item: $selectedPlace) { selectedPlace in
            RegistroDetailView(registro: selectedPlace)
        }
#else
        .popover(item: $selectedPlace, attachmentAnchor: .point(UnitPoint(x: 0.5, y: 0.5))) { selectedPlace in
            RegistroDetailView(registro: selectedPlace)
        }
#endif
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
            opacity: .constant(0.0), mapStyleSatellite: .constant(false))
}

