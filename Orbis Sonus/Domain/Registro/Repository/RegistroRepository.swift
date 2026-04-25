//
//  RegistroRepository.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 12/3/26.
//

protocol RegistroRepository {
    func fetchRegistros() async throws -> [Registro]
}
