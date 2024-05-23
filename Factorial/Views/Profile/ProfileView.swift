//
//  ProfileView.swift
//  Factorial
//
//  Created by Тимофей Юдин on 16.05.2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    @Binding var isPresenting: Bool
    
    var body: some View {
        NavigationStack {
            List {
                Button("Log Out") {
                    Task {
                        do {
                            try viewModel.signOut()
                            isPresenting.toggle()
                            return
                        } catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                }
                .foregroundStyle(Color.red)
                
                Section("") {
                    Button("Удалить аккаунт") {
                        Task {
                            do {
                                try await viewModel.delete()
                                isPresenting.toggle()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                .foregroundStyle(Color.red)
                
                Section("Account") {
                    if let _ = viewModel.user {
                        Text("Email: \(viewModel.user?.email ?? "email not found")")
                        
                        Button("Изменить пароль") {
                            Task {
                                do {
                                    try await viewModel.resetPassword()
                                    print("Success")
                                } catch {
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
                        }
                        .foregroundStyle(Color.blue)
                    }
                }
            }
            .task {
                try? await viewModel.loadCurrentUser()
            }
            .navigationTitle("Здравствуйте, \(viewModel.user?.name ?? "Name not found")")
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    ProfileView(isPresenting: .constant(true))
}
