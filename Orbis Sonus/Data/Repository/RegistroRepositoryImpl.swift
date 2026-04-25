//
//  RegistroRepositoryImpl.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 12/3/26.
//

class RegistroRepositoryImpl: RegistroRepository {

    private let dataSource: RegistroLocalDataSource

    init() {
        self.dataSource = RegistroLocalDataSource()
    }

    func fetchRegistros() async throws -> [Registro] {

        let dtoList = try dataSource.loadJSON()

        return dtoList.compactMap {
            $0.map()
        }
    }
}
