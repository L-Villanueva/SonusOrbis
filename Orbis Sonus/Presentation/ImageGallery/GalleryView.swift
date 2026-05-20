//
//  GalleryView.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 21/4/26.
//

import SwiftUI
import Combine


struct GalleryView: View {
    let images: [Image] = GalleryAsset.images
    @State private var showFull = false
    @State private var currentIndex: Int? = 0
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(spacing: 20) {
                        let itemHeight: CGFloat = 300
                        let itemWidth: CGFloat = geo.size.width - 120

                        carousel(itemHeight, itemWidth)
                            .id("carouselTop")
                        
                        // Hidden TabView to show native page indicators
                        hiddenTabView(index: $currentIndex)
                        
                        HStack {
                            Spacer()
                            VStack(spacing: 2) {
                                Text("Fotografia por:")
                                    .font(.caption2)
                                    .padding(.bottom, 4)
                                Text("Samuel Linares")
                                    .font(.caption2)
                                Text("Daniel Landaeta")
                                    .font(.caption2)
                            }
                        }
                        .padding(.horizontal)
                        
                        gallery(scrollProxy: scrollProxy)
                        Spacer()
                    }
                    .sheet(isPresented: $showFull) {
                        if let currentIndex {
                            images[currentIndex % images.count]
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
            }
        }
    }
    
    private func hiddenTabView(index: Binding<Int?>) -> some View {
        TabView(selection: index) {
            ForEach(0..<images.count, id: \.self) { index in
                Color.clear.tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .frame(height: 0)
        .padding(.top)
        .accessibilityHidden(true)
    }
    
    private func gallery(scrollProxy: ScrollViewProxy) -> some View {
        
        let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
        
        return LazyVGrid(columns: columns, spacing: 8) {
            ForEach(0..<images.count, id: \.self) { index in
                let image = images[index]
                GeometryReader { geo in
                    Button {
                        withAnimation {
                            currentIndex = index
                            scrollProxy.scrollTo("carouselTop", anchor: .top)
                        }
                    } label: {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.width)
                            .clipped()
                            .cornerRadius(8)
                    }
                }
                .aspectRatio(1, contentMode: .fit)
            }
        }
        .padding(.horizontal, 8)
    }
    
    private func carousel(_ itemHeight: CGFloat, _ itemWidth: CGFloat) -> some View {
        GeometryReader { proxy in
            let inset = max((proxy.size.width - itemWidth) / 2, 0)
            
            ScrollView(.horizontal) {
                HStack(spacing: 4) {
                    ForEach(0..<images.count, id: \.self) { index in
                        let image = images[index]
                        Button {
                            if index == currentIndex {
                                withAnimation(.default) {
                                    showFull = true
                                }
                            } else {
                                withAnimation(.easeInOut) {
                                    currentIndex = index
                                }
                            }
                        } label: {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: itemWidth, height: itemHeight)
                                .clipped()
                                .cornerRadius(16)
                                .shadow(radius: 4, y: 4)
                                .scaleEffect(index == currentIndex ? 1.0 : 0.8)
                                .animation(.easeInOut(duration: 0.25), value: currentIndex)
                        }
                        .id(index)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(inset, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .frame(height: itemHeight)
            .scrollPosition(id: $currentIndex, anchor: .center)
            .scrollIndicators(.hidden)
        }
        .frame(height: itemHeight)
    }
    
    private enum GalleryAsset: String, CaseIterable {
        case rcWeb2  = "RC WEB-2"
        case rcWeb3  = "RC WEB-3"
        case rcWeb4  = "RC WEB-4"
        case rcWeb15 = "RC WEB-15"
        case rcWeb16 = "RC WEB-16"
        case rcWeb18 = "RC WEB-18"
        case rcWeb20 = "RC WEB-20"
        case rcWeb27 = "RC WEB-27"
        case rcWeb35 = "RC WEB-35"
        case rcWeb41 = "RC WEB-41"
        case rcWeb48 = "RC WEB-48"
        case rcWeb50 = "RC WEB-50"
        case rcWeb51 = "RC WEB-51"
        case rcWeb55 = "RC WEB-55"

        var image: Image {
            Image(self.rawValue)
        }
        
        static var images: [Image] {
            GalleryAsset.allCases.map(\.image)
        }
    }
}

#Preview {
    NavigationView {
        GalleryView()
    }
}
