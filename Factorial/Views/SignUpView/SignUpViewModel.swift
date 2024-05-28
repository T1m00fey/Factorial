//
//  SignUpViewModel.swift
//  Factorial
//
//  Created by Тимофей Юдин on 13.05.2024.
//

import Foundation

@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var nameText = ""
    @Published var emailText = ""
    @Published var passwordText = ""
    
    @Published var isNameTFSelected = false
    @Published var isEmailTFSelected = false
    @Published var isPasswordTFSelected = false
    
    @Published var isNameEntered = false
    @Published var isEmailEntered = false
    @Published var isPasswordEntered = false
    
    @Published var isPopupPresenting = false
    @Published var errorText = ""
    
    func signUp() async throws {
        guard !emailText.isEmpty, !passwordText.isEmpty else {
            print("No email or password found.")
            return
        }
    
        let authDataResult = try await AuthenticationManager.shared.createUser(
            withEmail: emailText,
            andPassword: passwordText
        )
        
        let user = DBUser(
            userId: authDataResult.uid,
            name: nameText,
            email: emailText,
            dateCreated: Date()
        )
        
        try await UserManager.shared.createNewUser(user: user)
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
