//
//  ExpenseDetailedListView.swift
//  Expensiv
//
//  Created by Anusha NP on 9/9/2025.
//

import SwiftUI

struct ExpenseDetailedListView: View {
    var title: String
    var description: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                TextView(text: title, type: .caption)
                    .foregroundColor(Color.init(hex: "828282"))
                Spacer()
            }
            HStack {
                TextView(text: description, type: .body_1).foregroundColor(Color.text_primary_color)
                Spacer()
            }
        }
    }
}
