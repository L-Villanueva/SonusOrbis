//
//  RegistrosData.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 12/3/26.
//

import MapKit

struct RegistroDTO: Codable {
    let nombre: String
    let fuentes: String
    let audio: [String]
    let coordenadas: CoordenadasDTO
    let hora: String?
    let imagen: String?
    let video: String?
    let dia: String?
    let type: String?
}

struct CoordenadasDTO: Codable {
    let lat: Double?
    let lng: Double?
}

extension RegistroDTO {
    
    func coordinates() -> CLLocationCoordinate2D? {
        
        guard let lat = self.coordenadas.lat,
              let lng = self.coordenadas.lng else { return nil }
        
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    func typeFunction() -> RegistroType? {
        switch self.type ?? "" {
        case "motor":
            return .motor
        case "antropico":
            return .antropico
        case "atarraya":
            return .atarraya
        case "aves":
            return .aves
        case "naturaleza":
            return .naturaleza
        case "playa":
            return .playa
        default:
            return nil
        }
    }
    
    func map() -> Registro? {
        if let type = typeFunction() {
            return Registro(
                name: self.nombre,
                sources: self.fuentes,
                audio: self.audio,
                location: self.coordinates(),
                time: self.hora,
                image: self.imagen,
                video: self.video,
                date: self.dia,
                type: type
            )
        } else { return nil }
    }
}
