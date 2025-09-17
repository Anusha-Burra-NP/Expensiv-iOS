//
//  NavigationLazyView.swift
//  Expensiv
//
//  Created by Anusha NP on 11/9/2025.
//

import SwiftUI

// Lazy Navigation to load (constructor) after clicked on Button
struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content { build() }
}
