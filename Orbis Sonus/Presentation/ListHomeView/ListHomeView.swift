//
//  ListHomeView.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 12/3/26.
//

import SwiftUI
import MapKit

struct ListHomeView: View {

    @State private var selectedItem: Registro?
    @Binding var registros: [Registro]
    @Binding var filterQuery: String
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                Section {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("Buscar registros...", text: $filterQuery)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 6)
                    ForEach(registros, id: \.self) { registro in
                        Button {
                            selectedItem = registro
                        } label: {
                            VStack(alignment: .leading) {
                                Text(registro.name).font(.headline)
                                Text(registro.sources)
                            }
                        }
                    }
                } footer: {
                    Color.clear
                        .frame(height: 60)
                }
                
            }
            
            .listStyle(.automatic)
        }
        .sheet(item: $selectedItem) { item in
            RegistroDetailView(registro: item)
        }
    }
}

extension String: @retroactive Identifiable {
    public var id: String { self }
}

#Preview {
    @Previewable @State var registros = [
        Registro(
            name: "Canto de aves",
            sources: "Reserva natural",
            audio: [],
            location: CLLocationCoordinate2D(latitude: 10.3910, longitude: -75.4794),
            time: "06:30",
            image: nil,
            video: nil,
            date: "2026-03-12",
            type: .aves
        ),
        Registro(
            name: "Canto de aves",
            sources: "Reserva natural",
            audio: [],
            location: CLLocationCoordinate2D(latitude: 10.3910, longitude: -75.4794),
            time: "06:30",
            image: nil,
            video: nil,
            date: "2026-03-12",
            type: .aves
        ),
        Registro(
            name: "Canto de aves",
            sources: "Reserva natural",
            audio: [],
            location: CLLocationCoordinate2D(latitude: 10.3910, longitude: -75.4794),
            time: "06:30",
            image: nil,
            video: nil,
            date: "2026-03-12",
            type: .aves
        ),
        Registro(
            name: "Canto de aves",
            sources: "Reserva natural",
            audio: [],
            location: CLLocationCoordinate2D(latitude: 10.3910, longitude: -75.4794),
            time: "06:30",
            image: nil,
            video: nil,
            date: "2026-03-12",
            type: .aves
        ),
        Registro(
            name: "Canto de aves",
            sources: "Reserva natural",
            audio: [],
            location: CLLocationCoordinate2D(latitude: 10.3910, longitude: -75.4794),
            time: "06:30",
            image: nil,
            video: nil,
            date: "2026-03-12",
            type: .aves
        ),
        Registro(
            name: "Canto de aves",
            sources: "Reserva natural",
            audio: [],
            location: CLLocationCoordinate2D(latitude: 10.3910, longitude: -75.4794),
            time: "06:30",
            image: nil,
            video: nil,
            date: "2026-03-12",
            type: .aves
        ),
        Registro(
            name: "Canto de aves",
            sources: "Reserva natural",
            audio: [],
            location: CLLocationCoordinate2D(latitude: 10.3910, longitude: -75.4794),
            time: "06:30",
            image: nil,
            video: nil,
            date: "2026-03-12",
            type: .aves
        ),
        Registro(
            name: "Canto de aves",
            sources: "Reserva natural",
            audio: [],
            location: CLLocationCoordinate2D(latitude: 10.3910, longitude: -75.4794),
            time: "06:30",
            image: nil,
            video: nil,
            date: "2026-03-12",
            type: .aves
        ),
        Registro(
            name: "Canto de aves",
            sources: "Reserva natural",
            audio: [],
            location: CLLocationCoordinate2D(latitude: 10.3910, longitude: -75.4794),
            time: "06:30",
            image: nil,
            video: nil,
            date: "2026-03-12",
            type: .aves
        ),
        Registro(
            name: "Canto de aves",
            sources: "Reserva natural",
            audio: [],
            location: CLLocationCoordinate2D(latitude: 10.3910, longitude: -75.4794),
            time: "06:30",
            image: nil,
            video: nil,
            date: "2026-03-12",
            type: .aves
        ),
        Registro(
            name: "Canto de aves",
            sources: "Reserva natural",
            audio: [],
            location: CLLocationCoordinate2D(latitude: 10.3910, longitude: -75.4794),
            time: "06:30",
            image: nil,
            video: nil,
            date: "2026-03-12",
            type: .aves
        ),
        Registro(
            name: "Canto de aves",
            sources: "Reserva natural",
            audio: [],
            location: CLLocationCoordinate2D(latitude: 10.3910, longitude: -75.4794),
            time: "06:30",
            image: nil,
            video: nil,
            date: "2026-03-12",
            type: .aves
        )
    ]
    @Previewable @State var filterQuery = ""

    NavigationStack {
        ListHomeView(registros: $registros, filterQuery: $filterQuery)
    }
}


