//
//  VerticalLabelStyle.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import SwiftUI

struct VerticalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .center, spacing: 5) {
            configuration.icon
            configuration.title
        }
    }
}
