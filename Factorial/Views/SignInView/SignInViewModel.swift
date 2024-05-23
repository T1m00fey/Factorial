//
//  SignInViewModel.swift
//  Factorial
//
//  Created by Тимофей Юдин on 13.05.2024.
//

import Foundation

@MainActor
final class SignInViewModel: ObservableObject {
    @Published var emailText = ""
    @Published var passwordText = ""
    @Published var isFirstTFSelected = false
    @Published var isSecondTFSelected = false
    @Published var isEmailEntered = false
    @Published var isPasswordEntered = false
    @Published var isSignUpViewPresenting = false
    @Published var isProfileViewPresenting = false
    @Published var isForgotPasswordViewPresenting = false
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func signIn() async throws {
        guard !emailText.isEmpty, !passwordText.isEmpty else {
            print("No email or password found")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(withEmail: emailText, andPassword: passwordText)
    }
    
    func isDataEntered() -> Bool {
        if isEmailEntered && isPasswordEntered {
            return false
        } else {
            return true
            // disabled button
        }
    }
}
