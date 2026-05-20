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
        
    var body: some View {
        ZStack {
            ClusteredMapUIKitView(
                registros: $registros,
                selectedPlace: $selectedPlace,
                mapStyleSatellite: $mapStyleSatellite,
            )
            .edgesIgnoringSafeArea(.all)
            
            // Popup estilo Apple Maps
           /* Map {
                ForEach(registros) { place in
                    if let location = place.location, let icon = place.type.icon {
                        Annotation("", coordinate: location) {
                            ZStack(alignment: .center) {
                                
                                placeDetail(place)
                                
                                Button {
                                    detailAction(place)
                                } label: {
                                    Image(icon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 48)
                                }
                            }
                        }
                    }
                }
            }
            .mapStyle(mapStyleSatellite ? .hybrid : .standard)
            .preferredColorScheme(.light)*/
            Color.black.opacity(opacity)
                .edgesIgnoringSafeArea(.all)
        }
        .sheet(item: $selectedPlace) { selectedPlace in
            RegistroDetailView(registro: selectedPlace)
        }
    }
    
   /* private func placeDetail(_ place: Registro) -> some View {
        Group {
            if selectedPlace?.id == place.id {
                ScrollView {
                    VStack {
                        if let image = place.image {
                            Image(image)
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal)
                        }
                        if let date = place.date {
                            Text(date)
                        }
                        if let locationString = place.location?.string {
                            Text(locationString)
                        }
                        if let time = place.time {
                            Text(time)
                        }
                        Text(place.name)
                        if !place.audio.isEmpty {
                            ForEach(place.audio) { audio in
                                AudioPlayerView(audio: audio)
                            }
                        }
                    }
                }
                .padding(8)
                .background(.white)
                .cornerRadius(10)
                .shadow(radius: 4)
                .offset(y: -150) // lo sube sin mover el pin
                .transition(.scale.combined(with: .opacity))
                .animation(.linear, value: selectedPlace)
                .frame(maxWidth: 250, maxHeight: 250)
            }
        }
    }*/
    
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
            opacity: .constant(0.0), mapStyleSatellite: .constant(false))
}

