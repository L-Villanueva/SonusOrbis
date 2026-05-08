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
#if os(macOS)
        List(selection: $selectedItem) {
            ForEach(registros) { registro in
                VStack(alignment: .leading) {
                    Text(registro.name)
                        .font(.headline)
                    Text(registro.sources)
                }
                .padding(.vertical, 4)
                .tag(registro) // Make this row selectable
            }
        }
        .popover(item: $selectedItem) { item in
            RegistroDetailView(registro: item)
        }
#else
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
        .popover(item: $selectedItem, attachmentAnchor: .point(UnitPoint(x: 0.5, y: 0.5))) { item in
            RegistroDetailView(registro: item)
        }
#endif
    }
}

extension String: @retroactive Identifiable {
    public var id: String { self }
}


