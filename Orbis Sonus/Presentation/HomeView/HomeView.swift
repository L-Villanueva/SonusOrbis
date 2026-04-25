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
    @State var index: Int = 0
    
    var body: some View {
        ZStack {
            NavigationStack {
                Group {
                    switch index {
                    case 0:
                        MapHomeView(registros: $viewModel.registrosFiltered, filter: $viewModel.filterType)
                    case 1:
                        ListHomeView(registros: $viewModel.registrosFiltered)
                            .searchable(text: $viewModel.filterQuery,
                                        placement: .automatic,
                                        prompt: "Search fruits...")
                            .adaptiveLogo()
                    case 2:
                        GalleryView()
                            .adaptiveLogo()
                    case 3:
                        ProjectDetailView()
                            .adaptiveLogo()
                    case 4:
                        ContactView()
                            .adaptiveLogo()
                    default:
                        Text("\(index)")
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("", systemImage: "gear") {
                            viewModel.toggleSideNav()
                        }
                    }
                }
            }
            SideNavView(isShowingSideNav: $viewModel.isShowingSideNav, index: $index)
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
}

#Preview {
    HomeView()
}

