//
//  BottomNavView.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 12/3/26.
//

import SwiftUI

struct BottomNavView: View {
    
    @State var isShowingFilters: Bool = false
    @Binding var opacity: Double
    @Binding var mapStyleSatellite: Bool
    @Binding var filter: RegistroType?
    
    var filterTypes: [RegistroType] {
        RegistroType.allCases
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                if isShowingFilters {
                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(filterTypes, id: \.self) { type in
                                Button {
                                    guard filter != type else {
                                        self.filter = nil
                                        return
                                    }
                                    self.filter = type
                                } label: {
                                    HStack(alignment: .center) {
                                        Image(systemName: type == filter ? "checkmark.square.fill" : "square")
                                            .foregroundColor(type == filter ? .blue : .secondary)
                                        Text(type.rawValue.capitalized)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 26)
                        .glassModifier()
                        .clipShape(UnevenRoundedRectangle(cornerRadii:
                                                            RectangleCornerRadii(topLeading: 20,
                                                                                 topTrailing: 20)))
                        Spacer()
                    }
                }
                
                HStack {
                    BottomNavContent(isShowingFilters: $isShowingFilters, barValue: $opacity, stateButton: $mapStyleSatellite)
                    
                }
                .frame(height: 60)
                .padding(.horizontal, 26)
                .glassModifier()

                .clipShape(
                    isShowingFilters
                    ? UnevenRoundedRectangle(cornerRadii:
                                                RectangleCornerRadii(bottomLeading: 20,
                                                                     bottomTrailing: 20,
                                                                     topTrailing: 20))
                    : UnevenRoundedRectangle(cornerRadii:
                                                RectangleCornerRadii(topLeading: 20,
                                                                     bottomLeading: 20,
                                                                     bottomTrailing: 20,
                                                                     topTrailing: 20)))
                

            }
            .padding(.vertical, 40)
            .padding(.horizontal, 20)
            .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 2)
            .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 8)
        }
        .animation(.easeInOut, value: isShowingFilters)
    }
}

struct BottomNavContent: View {
    @Binding var isShowingFilters: Bool
    @Binding var barValue: Double
    @Binding var stateButton: Bool
    // change the action in these buttons based on your desired behavior
    var body: some View {
        HStack(spacing: 24) {
            Button("", systemImage: "house") {
                isShowingFilters.toggle()
            }
            
            Button("", systemImage: "house") {
                stateButton.toggle()
            }
                        
            Spacer()
            
            Slider(value: $barValue, in: 0...0.5)
                .frame(width: 160)
            
        }
    }
}

