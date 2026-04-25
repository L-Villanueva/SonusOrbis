//
//  RegistroLocalDataSource.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 12/3/26.
//

import Foundation

class RegistroLocalDataSource {

    func loadJSON() throws -> [RegistroDTO] {

        guard let url = Bundle.main.url(forResource: "registros_actualizados", withExtension: "json") else {
            throw NSError()
        }

        let data = try Data(contentsOf: url)

        let decoded = try JSONDecoder().decode(RegistrosResponseDTO.self, from: data)

        return decoded.registros
    }
}

struct RegistrosResponseDTO: Codable {
    let registros: [RegistroDTO]
}
