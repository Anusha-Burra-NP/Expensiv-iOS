//
//  TextView.swift
//  Expensiv
//
//  Created by Anusha NP on 9/9/2025.
//

import SwiftUI

struct TextView: View {
    var text: String
    var type: TextView_Type
    var lineLimit: Int = 0
    var body: some View {
        switch type {
        case .h1: return Text(text).tracking(-1.5).modifier(InterFont(.bold, size: 96)).lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .h2: return Text(text).tracking(-0.5).modifier(InterFont(.bold, size: 60)).lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .h3: return Text(text).tracking(0).modifier(InterFont(.bold, size: 48)).lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .h4: return Text(text).tracking(0.25).modifier(InterFont(.bold, size: 34)).lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .h5: return Text(text).tracking(0).modifier(InterFont(.semiBold, size: 24)).lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .h6: return Text(text).tracking(0.15).modifier(InterFont(.semiBold, size: 20)).lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .subtitle_1: return Text(text).tracking(0.15).modifier(InterFont(.bold, size: 16)).lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .subtitle_2: return Text(text).tracking(0.1).modifier(InterFont(.bold, size: 14)).lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .body_1: return Text(text).tracking(0.5).modifier(InterFont(.regular, size: 16)).lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .body_2: return Text(text).tracking(0.25).modifier(InterFont(.regular, size: 14)).lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .button: return Text(text).tracking(1.25).modifier(InterFont(.semiBold, size: 14)).lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .caption: return Text(text).tracking(0.4).modifier(InterFont(.medium, size: 12)).lineLimit(lineLimit == 0 ? .none : lineLimit)
        case .overline: return Text(text).tracking(1.5).modifier(InterFont(.semiBold, size: 10)).lineLimit(lineLimit == 0 ? .none : lineLimit)
        }
    }
}

enum InterFontType: String {
    case black = "Inter-Black"
    case bold = "Inter-Bold"
    case extraBold = "Inter-ExtraBold"
    case extraLight = "Inter-ExtraLight"
    case light = "Inter-Light"
    case medium = "Inter-Medium"
    case regular = "Inter-Regular"
    case semiBold = "Inter-SemiBold"
    case thin = "Inter-Thin"
}

struct InterFont: ViewModifier {
    
    var type: InterFontType
    var size: CGFloat
    
    init(_ type: InterFontType = .regular, size: CGFloat = 16) {
        self.type = type
        self.size = size
    }
    
    func body(content: Content) -> some View {
        content.font(Font.custom(type.rawValue, size: size))
    }
}
