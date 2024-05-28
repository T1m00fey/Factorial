//
//  ProfileViewModel.swift
//  Factorial
//
//  Created by Тимофей Юдин on 22.05.2024.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var user: DBUser? = nil
    
    @Published var errorText = ""
    @Published var isPopupPresenting = false
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(withEmail: email)
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func delete() async throws {
        guard let user = user else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await UserManager.shared.deleteUser(user: user)
        try await AuthenticationManager.shared.delete()
    }
}
