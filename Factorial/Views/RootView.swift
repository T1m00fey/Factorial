//
//  RootView.swift
//  Factorial
//
//  Created by Тимофей Юдин on 24.05.2024.
//

import SwiftUI

struct RootView: View {
    @State private var isSignInViewShowing = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                ProfileView(isSignInViewPresenting: $isSignInViewShowing)
            }
            .onAppear {
                let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
                self.isSignInViewShowing = authUser == nil
            }
            .fullScreenCover(isPresented: $isSignInViewShowing) {
                NavigationStack {
                    SignInView(isPresenting: $isSignInViewShowing)
                }
            }
        }
    }
}

#Preview {
    RootView()
}
