//
//  ContactView.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 25/4/26.
//

import SwiftUI

struct ContactView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text(lorem)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.top, 28)
            
            HStack(spacing: 16) {
                Image(systemName: "envelope")
                VStack(spacing: 8) {
                    Text("danielandaeta98@gmail.com")
                        .font(.body)
                    Text("orbis.sonus@gmail.com")
                        .font(.body)
                }
            }
            Spacer()
        }
        .padding()
    }
}


private let lorem = """
Este proyecto nace con una visión abierta y en constante crecimiento. La meta es expandir esta plataforma para que investigadores, sonidistas, ambientalistas y ciudadanos de cualquier parte del mundo puedan aportar sus propios registros sonoros de espacios naturales, parques nacionales y entornos de valor ecológico o cultural.

Cada nueva contribución permitirá fortalecer un archivo colaborativo orientado a la preservación ambiental, la memoria acústica y el monitoreo de cambios en los ecosistemas a través del tiempo. De esta manera, el mapa sonoro podrá evolucionar hacia una red internacional de documentación sonora al servicio de la conservación.

Si deseas colaborar, compartir registros o sumar información de otros parques y locaciones, encontrarás mi contacto a continuación.
"""

#Preview {
    ContactView()
}
