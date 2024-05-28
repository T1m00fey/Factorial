//
//  SignInView.swift
//  Factorial
//
//  Created by Тимофей Юдин on 12.05.2024.
//

import SwiftUI
import PopupView

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel()
    
    @Binding var isPresenting: Bool
    
    @FocusState var firstTFFocused: Bool
    @FocusState var secondTFFocused: Bool
    
    init(isPresenting: Binding<Bool>) {
        self._isPresenting = isPresenting
        
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemBackground)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            firstTFFocused = false
                            secondTFFocused = false
                            
                            viewModel.isFirstTFSelected = false
                            viewModel.isSecondTFSelected = false
                        }
                    }
                
                VStack {
                    Spacer()
                    
                    Text("Войти")
                        .font(.title)
                        .fontDesign(.monospaced)
                    
                    TextField("Email", text: $viewModel.emailText)
                        .tint(Color(uiColor: .label))
                        .frame(width: UIScreen.main.bounds.width - 64)
                        .font(.title2)
                        .focused($firstTFFocused, equals: true)
                        .padding(.top, 20)
                        .textInputAutocapitalization(.never)
                        .onChange(of: firstTFFocused) { oldValue, newValue in
                            withAnimation {
                                if newValue {
                                    viewModel.isFirstTFSelected = true
                                    viewModel.isSecondTFSelected = false
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
                        .foregroundStyle(Color(uiColor: viewModel.isFirstTFSelected ? .label : .systemGray2))
                    
                    SecureField("Пароль", text: $viewModel.passwordText)
                        .tint(Color(uiColor: .label))
                        .frame(width: UIScreen.main.bounds.width - 64)
                        .font(.title2)
                        .focused($secondTFFocused, equals: true)
                        .padding(.top, 40)
                        .textInputAutocapitalization(.never)
                        .onChange(of: secondTFFocused) { oldValue, newValue in
                            withAnimation {
                                if newValue {
                                    viewModel.isFirstTFSelected = false
                                    viewModel.isSecondTFSelected = true
                                }
                            }
                        }
                        .onChange(of: viewModel.passwordText) { oldValue, newValue in
                            if newValue != "" {
                                withAnimation {
                                    viewModel.isPasswordEntered = true
                                }
                            } else {
                                withAnimation {
                                    viewModel.isPasswordEntered = false
                                }
                            }
                        }
                    
                    
                    RoundedRectangle(cornerRadius: 0)
                        .frame(width: UIScreen.main.bounds.width - 64, height: 3)
                        .foregroundStyle(Color(uiColor: viewModel.isSecondTFSelected ? .label : .systemGray2))
                    
                    Button {
                        Task {
                            do {
                                try await viewModel.signIn()
                                isPresenting = false
                                
                                viewModel.emailText = ""
                                viewModel.passwordText = ""
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
                        HStack {
                            Text("Войти")
                            
                            Image(systemName: "arrow.right")
                        }
                        .foregroundStyle(
                            Color(
                                uiColor: viewModel.isEmailEntered && viewModel.isPasswordEntered ? .label : .gray
                            )
                        )
                        .font(.title2)
                        .fontDesign(.monospaced)
                        .padding(.top, 20)
                    }
                    .disabled(viewModel.isDataEntered())
                    
                    Spacer()
                    
                    HStack(spacing: 30) {
                        Text("Регистрация")
                            .font(.subheadline)
                            .fontDesign(.monospaced)
                            .underline()
                            .foregroundStyle(Color.blue)
                            .padding(.bottom, 20)
                            .onTapGesture {
                                viewModel.isSignUpViewPresenting.toggle()
                            }
                        
                        Text("Забыли пароль?")
                            .font(.subheadline)
                            .fontDesign(.monospaced)
                            .underline()
                            .foregroundStyle(Color.blue)
                            .padding(.bottom, 20)
                            .onTapGesture {
                                viewModel.isForgotPasswordViewPresenting.toggle()
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
                .fullScreenCover(isPresented: $viewModel.isSignUpViewPresenting, content: {
                    SignUpView(isScreenPresenting: $viewModel.isSignUpViewPresenting, isSignInViewPresenting: $isPresenting)
                })
                .navigationDestination(isPresented: $viewModel.isForgotPasswordViewPresenting, destination: {
                    ForgotPasswordView()
                })
                .onChange(of: isPresenting, { oldValue, newValue in
                    if !newValue {
                        viewModel.emailText = ""
                        viewModel.passwordText = ""
                        
                        viewModel.isFirstTFSelected = false
                        viewModel.isSecondTFSelected = false
                    }
                })
            }
        }
    }
}

#Preview {
    SignInView(isPresenting: .constant(true))
}
