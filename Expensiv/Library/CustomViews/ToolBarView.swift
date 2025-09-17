//
//  ToolBarView.swift
//  Expensiv
//
//  Created by Anusha NP on 8/9/2025.
//

import Foundation
import SwiftUI

struct ToolbarView: View {
    
    var title: String
    var hasBackButt: Bool = true
    var button1Icon: String?
    var button2Icon: String?
    
    var backButtonClick: () -> ()
    var button1Method: (() -> ())?
    var button2Method: (() -> ())?
    
    var body: some View {
        ZStack {
            HStack {
                if hasBackButt {
                    Button(action: {
                        self.backButtonClick()
                    }, label: {
                        Image(systemName: Constants.chevronLeftIcon)
                            .fontWeight(.bold)
                            .frame(width: 24.0, height: 24.0)
                            .foregroundStyle(Color.white)
                    })
                }
                Spacer()
                
                if let button2Method = self.button2Method {
                    Button(action: {
                        button2Method()
                    }, label: {
                        Image(button2Icon ?? "")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24.0, height: 24.0)
                            .foregroundStyle(Color.white)
                    }).padding(.horizontal, 8)
                }
                
                if let button1Method = self.button1Method {
                    Button(action: {
                        button1Method()
                    },
                           label: {
                        Image(button1Icon ?? "")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24.0, height: 24.0)
                            .foregroundStyle(Color.white)
                    }).padding(.horizontal, 8)
                }
            }
            HStack {
                TextView(text: title, type: .h6)
                    .foregroundColor(Color.white)
                if !hasBackButt {
                    Spacer()
                }
            }
        }.padding(16)
            .padding(.top, 50)
            .padding(.horizontal, 8)
            .background(Color.main)
    }
}
