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
    @Binding var mapStyleSatellite: Bool
    var body: some View {
        ZStack {
            MapView(registros: $registros,
                    mapStyleSatellite: $mapStyleSatellite)
            
           
        }
    }
}
