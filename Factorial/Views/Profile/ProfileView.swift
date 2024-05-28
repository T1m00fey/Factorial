//
//  ProfileView.swift
//  Factorial
//
//  Created by Тимофей Юдин on 16.05.2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    @Binding var isSignInViewPresenting: Bool
    
    var body: some View {
        NavigationStack {
            List {
                Button("Log Out") {
                    Task {
                        do {
                            try viewModel.signOut()
                            isSignInViewPresenting.toggle()
                            return
                        } catch {
                            print("Error: \(error.localizedDescription)")
                            
                            withAnimation {
                                viewModel.errorText = error.localizedDescription
                            }
                        }
                        
                        viewModel.isPopupPresenting = true
                    }
                }
                .foregroundStyle(Color.red)
                
                Section("") {
                    Button("Удалить аккаунт") {
                        Task {
                            do {
                                try await viewModel.delete()
                                isSignInViewPresenting.toggle()
                                
                                return
                            } catch {
                                print(error.localizedDescription)
                                
                                withAnimation {
                                    viewModel.errorText = error.localizedDescription
                                }
                            }
                            
                            viewModel.isPopupPresenting = true
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
                                    
                                    return
                                } catch {
                                    print("Error: \(error.localizedDescription)")
                                    
                                    withAnimation {
                                        viewModel.errorText = error.localizedDescription
                                    }
                                }
                                
                                viewModel.isPopupPresenting = true
                            }
                        }
                        .foregroundStyle(Color.blue)
                    }
                }
            }
            .task {
                try? await viewModel.loadCurrentUser()
            }
            .navigationTitle("Здравствуйте, \(viewModel.user?.name ?? "name not found")")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .onChange(of: isSignInViewPresenting) { oldValue, newValue in
                if !newValue {
                    Task {
                        try? await viewModel.loadCurrentUser()
                    }
                }
            }
            .popup(isPresented: $viewModel.isPopupPresenting) {
                Text(viewModel.errorText)
                    .frame(width: UIScreen.main.bounds.width - 72)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .foregroundStyle(Color.white)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } customize: {
                $0
                    .type(.floater())
                    .position(.top)
                    .animation(.bouncy)
                    .dragToDismiss(true)
                    .autohideIn(7)
            }
        }
    }
}

#Preview {
    ProfileView(isSignInViewPresenting: .constant(true))
}
