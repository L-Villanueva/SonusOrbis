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
    
    var body: some View {
        List(registros, id: \.self) { registro in
            Button {
                selectedItem = registro
            } label: {
                VStack(alignment: .leading) {
                    Text(registro.name).font(.headline)
                    Text(registro.sources)
                }
            }
        }
        .sheet(item: $selectedItem) { item in
            RegistroDetailView(registro: item)
        }
    }
}

extension String: @retroactive Identifiable {
    public var id: String { self }
}


