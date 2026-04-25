//
//  GetRegistrosUseCase.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 12/3/26.
//

import Foundation

class GetRegistrosUseCase {

    private let repository: RegistroRepository

    init() {
        self.repository = RegistroRepositoryImpl()
    }

    func execute() async throws -> [Registro] {
        try await repository.fetchRegistros()
    }
}
