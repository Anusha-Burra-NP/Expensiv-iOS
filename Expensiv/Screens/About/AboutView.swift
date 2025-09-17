//
//  AboutView.swift
//  Expensiv
//
//  Created by Anusha NP on 8/9/2025.
//

import SwiftUI

struct AboutView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.primary_color.edgesIgnoringSafeArea(.all)
                VStack {
                    ToolbarView(title: Constants.aboutText) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                    Spacer().frame(height: 80)
                    
                    Image(Constants.appIcon).resizable().frame(width: 120.0, height: 120.0)
                    TextView(text: "\(Constants.AppName)", type: .h6).foregroundColor(Color.text_primary_color).padding(.top, 20)
                    TextView(text: "v\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] ?? "")", type: .body_2)
                        .foregroundColor(Color.text_secondary_color).padding(.top, 2)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .center, spacing: 4) {
                            HStack { Spacer() }
                            TextView(text: "\(Constants.AppLink)", type: .body_2)
                                .foregroundColor(Color.main_color).padding(.top, 2)
                                .onTapGesture {
                                    if let url: URL = URL(string: Constants.AppLink) {
                                        UIApplication.shared.open(url)
                                    }
                                }
                        }
                    }.padding(20)
                    
                    Spacer()
                }.edgesIgnoringSafeArea(.all)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AboutView()
}
