//
//  EnvironmentPreviewWrapper.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//

import SwiftUI

struct EnvironmentPreviewWrapper<Content: View> : View {
    var appEnvironment = AppEnvironment.bootstrap(isPreview: true)
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        content()
            .modelContainer(appEnvironment.modelContainer)
            .inject(appEnvironment.diContainer)
    }
}

#Preview {
    EnvironmentPreviewWrapper {
        Text("Hello")
    }
}
