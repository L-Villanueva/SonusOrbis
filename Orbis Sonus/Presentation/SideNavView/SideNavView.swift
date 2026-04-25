//
//  SideNavView.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 11/3/26.
//

import SwiftUI

struct SideNavView: View {
    @Binding var isShowingSideNav: Bool
    @Binding var route: HomeView.ViewModel.Router
    
    var body: some View {
        ZStack {
            if isShowingSideNav {
                
                Button {
                    isShowingSideNav.toggle()
                } label: {
                    Rectangle()
                        .fill(Color.primary.opacity(0.3))
                        .ignoresSafeArea()
                }
                .accessibilityLabel("dismiss")
                
                HStack {
                    VStack {
                        // We are using a ScrollView here instead of a List because
                        // a List is a greedy view (meaning it wants to take as much space as possible)
                        // and a ScrollView is not, meaning that it will only take up as much space as the components in the view.
                        // We are not concerned about performance here because this component should only hold a small amount of small views.
                        ScrollView {
                            // Side nav content goes here
                            SideNavContent(isShowingSideNav: $isShowingSideNav, route: $route)
                        }
                        .padding(.top, 80)
                        
                        // This spacer allows the content to fill the
                        // height of the screen
                        Spacer()
                    }
                    .padding()
                    .background()
                    
                    // This spacer pushes the HStack to the
                    // leading side of the screen
                    Spacer()
                }
                
                // animate the view from the leading edge
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut, value: isShowingSideNav)
        
        // If you find the navigation of your app appearing above your side nav,
        // you can turn off the navigation toolbar while the side nav is displayed
    }
}

// Place the content for your side nav in this view
struct SideNavContent: View {
    @Binding var isShowingSideNav: Bool
    @Binding var route: HomeView.ViewModel.Router

    // change the action in these buttons based on your desired behavior
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Button("Home", systemImage: "house") {
                isShowingSideNav.toggle()
                route = .showMap
            }
                        
            Button("List", systemImage: "list.bullet") {
                isShowingSideNav.toggle()
                route = .showList
            }
            
            Button("Gallery", systemImage: "photo.on.rectangle") {
                isShowingSideNav.toggle()
                route = .showGallery
            }
            
            Button("Info", systemImage: "person.3") {
                isShowingSideNav.toggle()
                route = .showInfo
            }
            Button("Contact", systemImage: "person.3") {
                isShowingSideNav.toggle()
                route = .showContact
            }
        }
    }
}
