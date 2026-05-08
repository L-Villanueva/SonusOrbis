//
//  HomeView.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 26/12/25.
//
import SwiftUI
import MapKit
import Combine

struct HomeView: View {
    
    @StateObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        ZStack {
            NavigationStack {
                Group {
                    switch viewModel.route {
                    case .showMap:
                        MapHomeView(registros: $viewModel.registrosFiltered, filter: $viewModel.filterType)
                    case .showList:
                        ListHomeView(registros: $viewModel.registrosFiltered)
                            .searchable(text: $viewModel.filterQuery,
                                        placement: .automatic,
                                        prompt: "Search fruits...")
                            .adaptiveLogo()
                    case .showGallery:
                        GalleryView()
                            .adaptiveLogo()
                    case .showInfo:
                        ProjectInfoView()
                            .adaptiveLogo()
                    case .showContact:
                        ContactView()
                            .adaptiveLogo()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: toolbarPlacement) {
                        Button("", systemImage: "gear") {
                            viewModel.toggleSideNav()
                        }
                    }
                }
            }
            SideNavView(isShowingSideNav: $viewModel.isShowingSideNav, route: $viewModel.route)
        }
        .task {
            await viewModel.load()
        }
        .onChange(of: viewModel.filterType) {
            viewModel.filterByType()
        }
        .onChange(of: viewModel.filterQuery) {
            viewModel.filterByQuery()
        }
    }
    
    private var toolbarPlacement: ToolbarItemPlacement {
        #if os(macOS)
        .navigation
        #else
        .topBarLeading
        #endif
    }
}

#Preview {
    HomeView()
}

