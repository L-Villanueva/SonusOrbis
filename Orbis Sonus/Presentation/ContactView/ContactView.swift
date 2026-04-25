//
//  ContactView.swift
//  Orbis Sonus
//
//  Created by Luis Villanueva on 25/4/26.
//

import SwiftUI

struct ContactView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text(lorem)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.top, 28)
            
            HStack(spacing: 16) {
                Image(systemName: "envelope")
                VStack(spacing: 8) {
                    Text("daniellandaeta98@gmail.com")
                        .font(.body)
                    Text("orbis.sonus@gmail.com")
                        .font(.body)
                }
            }
            Spacer()
        }
        .padding()
    }
}


private let lorem = """
Lorem ipsum dolor sit amet consectetur. Blandit nulla venenatis nunc mattis at tristique etiam vestibulum. Orci adipiscing ultrices enim egestas eget porttitor. Vulputate egestas eros semper at sagittis. Sed accumsan mauris purus accumsan phasellus maecenas cras. Convallis cursus posuere nunc eget ac lacus eu senectus duis. Arcu facilisis netus arcu consequat in lobortis nisl. Vel feugiat in nec a non sollicitudin sit magnis lectus. Aliquet tellus phasellus et fringilla arcu semper. Pulvinar ut porta fermentum ipsum orci imperdiet.
"""

#Preview {
    ContactView()
}
