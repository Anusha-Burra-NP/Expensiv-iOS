//
//  AuthenticationView.swift
//  Expensiv
//
//  Created by Anusha NP on 12/9/2025.
//

import SwiftUI

struct AuthenticationView: View {
    
    @ObservedObject var viewModel: AuthenticationViewModel
    @State private var isAuthenticated = false
    
    var body: some View {
        NavigationStack {
            // The ZStack and all its content are now the single child of NavigationStack
            ZStack {
                Color.primary_color.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    Image(Constants.appIcon).resizable().frame(width: 120.0, height: 120.0)
                    VStack(spacing: 16) {
                        TextView(text: "\(Constants.AppName) is locked", type: .body_1)
                            .foregroundColor(Color.text_primary_color)
                            .padding(.top, 20)
                        Button(action: { viewModel.authenticate() }, label: {
                            HStack {
                                Spacer()
                                TextView(text: Constants.unlockText, type: .button)
                                    .foregroundColor(Color.main_color)
                                Spacer()
                            }
                        })
                        .frame(height: 25)
                        .padding().background(Color.secondary_color)
                        .cornerRadius(4)
                        .foregroundColor(Color.text_primary_color)
                        .accentColor(Color.text_primary_color)
                    }.padding(.horizontal)
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
            }
            .navigationDestination(isPresented: $isAuthenticated) {
                NavigationLazyView(ExpenseView())
            }
        }
        .onAppear(perform: {
            viewModel.authenticate()
        })
        .onReceive(viewModel.$didAuthenticate) { didAuthenticate in
            isAuthenticated = didAuthenticate
        }
    }
}

#Preview {
    AuthenticationView(viewModel: AuthenticationViewModel())
}
