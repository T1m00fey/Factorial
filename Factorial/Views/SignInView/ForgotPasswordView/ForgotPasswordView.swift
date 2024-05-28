//
//  ForgotPasswordView.swift
//  Factorial
//
//  Created by Тимофей Юдин on 22.05.2024.
//

import SwiftUI

@MainActor
final class ForgotPasswordViewModel: ObservableObject {
    @Published var emailText = ""
    @Published var isTFSelected = false
    @Published var isEmailEntered = false
    @Published var errorText = ""
    @Published var isPopupPresenting = false
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(withEmail: email)
    }
}

struct ForgotPasswordView: View {
    @StateObject private var viewModel = ForgotPasswordViewModel()
    
    @FocusState var tfFocused: Bool
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemBackground)
                    .ignoresSafeArea()
                    .onTapGesture {
                        tfFocused = false
                    }
                
                VStack {
                    Spacer()
                    
                    Text("Восстановление пароля")
                        .font(.title2)
                        .fontDesign(.monospaced)
                    
                    TextField("Email", text: $viewModel.emailText)
                        .tint(Color(uiColor: .label))
                        .frame(width: UIScreen.main.bounds.width - 64)
                        .font(.title2)
                        .focused($tfFocused, equals: true)
                        .padding(.top, 30)
                        .textInputAutocapitalization(.never)
                        .onChange(of: tfFocused) { oldValue, newValue in
                            withAnimation {
                                if newValue {
                                    viewModel.isTFSelected = true
                                } else {
                                    viewModel.isTFSelected = false
                                }
                            }
                        }
                        .onChange(of: viewModel.emailText) { oldValue, newValue in
                            if newValue != "" {
                                withAnimation {
                                    viewModel.isEmailEntered = true
                                }
                            } else {
                                withAnimation {
                                    viewModel.isEmailEntered = false
                                }
                            }
                        }
                    
                    RoundedRectangle(cornerRadius: 0)
                        .frame(width: UIScreen.main.bounds.width - 64, height: 3)
                        .foregroundStyle(Color(uiColor: viewModel.isTFSelected ? .label : .systemGray2))
                    
                    Button {
                        Task {
                            do {
                                try await viewModel.resetPassword()
                                print("PASSWORD RESET")
                                
                                viewModel.isTFSelected = false
                                viewModel.emailText = ""
                                
                                dismiss()
                                
                                return
                            } catch {
                                print("Error: \(error.localizedDescription)")
                                
                                withAnimation {
                                    viewModel.errorText = error.localizedDescription
                                }
                            }
                            
                            viewModel.isPopupPresenting = true
                        }
                    } label: {
                        Text("Готово")
                    }
                    .foregroundStyle(
                        Color(
                            uiColor: viewModel.isEmailEntered ? .label : .gray
                        )
                    )
                    .font(.title2)
                    .fontDesign(.monospaced)
                    .padding(.top, 30)
                    .disabled(!viewModel.isEmailEntered)
                    
                    Spacer()
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
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                                .foregroundStyle(Color(uiColor: .label))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
}
