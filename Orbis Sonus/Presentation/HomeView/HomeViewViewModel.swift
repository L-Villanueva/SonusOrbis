//
//  HomeViewViewModel.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 11/3/26.
//
import Combine

extension HomeView {
    @MainActor
    class ViewModel: ObservableObject {
        private var registros: [Registro] = []

        @Published var isShowingSideNav: Bool = false
        @Published var registrosFiltered: [Registro] = []
        @Published var filterType: RegistroType? = nil
        @Published var filterQuery: String = ""
        @Published var route: Router = .showMap
        
        let useCase = GetRegistrosUseCase()
        
        func load() async {
            do {
                registros = try await useCase.execute()
                registrosFiltered = registros
            } catch {
                print("Error loading registros")
            }
        }
        
        func toggleSideNav() {
            isShowingSideNav.toggle()
        }
        
        func filterByType() {
            if let filterType {
                registrosFiltered = registros.filter { $0.type == filterType}
            } else {
                registrosFiltered = registros
            }
        }
        
        func filterByQuery() {
            if !filterQuery.isEmpty {
                registrosFiltered = registros.filter { registro in
                    registro.name.lowercased().contains(filterQuery.lowercased())
                }
            } else {
                registrosFiltered = registros
            }
        }
        
        enum Router {
            case showInfo
            case showGallery
            case showList
            case showMap
            case showContact
        }
    }
}
