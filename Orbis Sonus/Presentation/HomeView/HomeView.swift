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
    @StateObject private var audioPlayerManager = AudioPlayerManager()
    @State private var mapStyleSatellite: Bool = false

    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    Group {
                        switch viewModel.route {
                        case .showMap:
                            MapHomeView(registros: $viewModel.registrosFiltered, filter: $viewModel.filterType, mapStyleSatellite: $mapStyleSatellite)
                        case .showList:
                            ListHomeView(registros: $viewModel.registrosFiltered,
                                         filterQuery: $viewModel.filterQuery)
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
                        ToolbarItem(placement: .topBarLeading) {
                            Button("", systemImage: "gear") {
                                viewModel.toggleSideNav()
                            }
                        }
                    }

                    if viewModel.route == .showMap || (viewModel.route == .showList && audioPlayerManager.hasActiveTrack) {
                        BottomNavView(mapStyleSatellite: $mapStyleSatellite,
                                      filter: $viewModel.filterType,
                                      showsMapControls: viewModel.route == .showMap)
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
        .environmentObject(audioPlayerManager)
    }
}

#Preview {
    HomeView()
}

