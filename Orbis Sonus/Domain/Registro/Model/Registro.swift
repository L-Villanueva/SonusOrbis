//
//  Registro.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 12/3/26.
//

import MapKit

struct Registro: Hashable, Equatable, Identifiable {
    let id = UUID()
    let name: String
    let sources: String
    let audio: [String]
    let location: CLLocationCoordinate2D?
    let time: String?
    let image: String?
    let video: String?
    let date: String?
    let type: RegistroType
    
    static func == (lhs: Registro, rhs: Registro) -> Bool {
        return lhs.name == rhs.name &&
        lhs.sources == rhs.sources &&
        lhs.audio == rhs.audio &&
        ((lhs.location == nil && rhs.location == nil) || (lhs.location?.latitude == rhs.location?.latitude && lhs.location?.longitude == rhs.location?.longitude)) &&
        lhs.time == rhs.time &&
        lhs.image == rhs.image &&
        lhs.video == rhs.video &&
        lhs.date == rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(sources)
        hasher.combine(audio)
        if let loc = location {
            hasher.combine(loc.latitude)
            hasher.combine(loc.longitude)
        } else {
            hasher.combine(0.0 as Double)
            hasher.combine(0.0 as Double)
        }
        hasher.combine(time)
        hasher.combine(image)
        hasher.combine(video)
        hasher.combine(date)
    }
}

enum RegistroType: String, Codable, CaseIterable {
    
    case motor
    case antropico
    case naturaleza
    case atarraya
    case playa
    case aves
    
    var icon: ImageResource? {
        switch self {
        case .motor:
            return .lanchaIcon
        case .antropico:
            return .antropicoIcon
        case .naturaleza:
            return .naturalezaIcon
        case .atarraya:
            return .atarrayaIcon
        case .playa:
            return .playaIcon
        case .aves:
            return .avesIcon
        }
    }
}


extension CLLocationCoordinate2D {
    var string: String {
        "\(self.latitude), \(self.longitude)"
    }
}
