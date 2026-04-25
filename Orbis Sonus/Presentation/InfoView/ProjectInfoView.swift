//
//  ProjectInfoView.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 24/4/26.
//


import SwiftUI

struct ProjectInfoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Image(.yemayao)
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 32)

                Text("Acerca del proyecto")
                    .font(.title3)
                    .padding(.top, 28)

                Text(lorem)
                    .font(.body)
                    .padding(.top, 28)

                HStack {
                    Spacer()

                    Button("Link a proyecto de grado") {
                        // Abrir link
                    }
                    .font(.system(.body, design: .monospaced))
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 26)
                    .padding(.vertical, 16)
                    .background(Color.purple.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    Spacer()
                }
                .padding(.top, 56)

                Text("Especies")
                    .font(.title3)
                    .padding(.top, 72)

                Text(lorem)
                    .font(.body)
                    .padding(.top, 28)
            }
            .padding(.horizontal, 36)
            .padding(.bottom, 40)
        }
        .background(Color.white)
    }
}

private struct ImagePlaceholder: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(.systemGray6))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray3), lineWidth: 2)
            }
            .overlay {
                Image(systemName: "photo")
                    .font(.system(size: 24))
                    .foregroundStyle(Color(.systemGray3))
            }
    }
}

private let lorem = """
Lorem ipsum dolor sit amet consectetur. Blandit nulla venenatis nunc mattis at tristique etiam vestibulum. Orci adipiscing ultrices enim egestas eget porttitor. Vulputate egestas eros semper at sagittis. Sed accumsan mauris purus accumsan phasellus maecenas cras. Convallis cursus posuere nunc eget ac lacus eu senectus duis. Arcu facilisis netus arcu consequat in lobortis nisl. Vel feugiat in nec a non sollicitudin sit magnis lectus. Aliquet tellus phasellus et fringilla arcu semper. Pulvinar ut porta fermentum ipsum orci imperdiet.
"""

#Preview {
    ProjectInfoView()
}
