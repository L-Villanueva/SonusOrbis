//
//  MapHomeView.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 12/3/26.
//

import SwiftUI

struct MapHomeView: View {
    
    @Binding var registros: [Registro]
    @Binding var filter: RegistroType?
    @State private var opacity: Double = 0
    @State private var mapStyleSatellite: Bool = false
    var body: some View {
        ZStack {
            MapView(registros: $registros,
                    opacity: $opacity,
                    mapStyleSatellite: $mapStyleSatellite)
            
            BottomNavView(opacity: $opacity,
                          mapStyleSatellite: $mapStyleSatellite,
                          filter: $filter)
                
            
        }
    }
}

#Preview {
    struct MapHomeView_Previews: View {
        @State private var registros: [Registro] = []
        @State private var filter: RegistroType? = nil
        var body: some View {
            MapHomeView(registros: $registros, filter: $filter)
        }
    }
    return MapHomeView_Previews()
}
