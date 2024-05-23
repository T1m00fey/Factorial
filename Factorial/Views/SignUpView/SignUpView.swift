//
//  SignUpView.swift
//  Factorial
//
//  Created by Тимофей Юдин on 13.05.2024.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    
    @Binding var isScreenPresenting: Bool
    
    @FocusState var nameTFFocused: Bool
    @FocusState var emailTFFocused: Bool
    @FocusState var passwordTFFocused: Bool
    
    init(isScreenPresenting: Binding<Bool>) {
        self._isScreenPresenting = isScreenPresenting
        
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemBackground)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            emailTFFocused = false
                            passwordTFFocused = false
                            
                            viewModel.isEmailTFSelected = false
                            viewModel.isPasswordTFSelected = false
                        }
                    }
                
                VStack {
                    Spacer()
                    
                    Text("Регистрация")
                        .font(.title)
                        .fontDesign(.monospaced)
                    
                    TextField("Имя", text: $viewModel.nameText)
                        .tint(Color(uiColor: .label))
                        .frame(width: UIScreen.main.bounds.width - 64)
                        .font(.title2)
                        .focused($nameTFFocused, equals: true)
                        .padding(.top, 20)
                        .textInputAutocapitalization(.never)
                        .onChange(of: nameTFFocused) { oldValue, newValue in
                            withAnimation {
                                if newValue {
                                    viewModel.isNameTFSelected = true
                                    viewModel.isEmailTFSelected = false
                                    viewModel.isPasswordTFSelected = false
                                }
                            }
                        }
                        .onChange(of: viewModel.nameText) { oldValue, newValue in
                            if newValue != "" {
                                withAnimation {
                                    viewModel.isNameEntered = true
                                }
                            } else {
                                withAnimation {
                                    viewModel.isNameEntered = false
                                }
                            }
                        }
                    
                    RoundedRectangle(cornerRadius: 0)
                        .frame(width: UIScreen.main.bounds.width - 64, height: 3)
                        .foregroundStyle(Color(uiColor: viewModel.isNameTFSelected ? .label : .systemGray2))
                    
                    TextField("Email", text: $viewModel.emailText)
                        .tint(Color(uiColor: .label))
                        .frame(width: UIScreen.main.bounds.width - 64)
                        .font(.title2)
                        .focused($emailTFFocused, equals: true)
                        .padding(.top, 40)
                        .textInputAutocapitalization(.never)
                        .onChange(of: emailTFFocused) { oldValue, newValue in
                            withAnimation {
                                if newValue {
                                    viewModel.isNameTFSelected = false
                                    viewModel.isEmailTFSelected = true
                                    viewModel.isPasswordTFSelected = false
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
                        .foregroundStyle(Color(uiColor: viewModel.isEmailTFSelected ? .label : .systemGray2))
                    
                    SecureField("Пароль", text: $viewModel.passwordText)
                        .tint(Color(uiColor: .label))
                        .frame(width: UIScreen.main.bounds.width - 64)
                        .font(.title2)
                        .focused($passwordTFFocused, equals: true)
                        .padding(.top, 40)
                        .textInputAutocapitalization(.never)
                        .onChange(of: passwordTFFocused) { oldValue, newValue in
                            withAnimation {
                                if newValue {
                                    viewModel.isNameTFSelected = false
                                    viewModel.isEmailTFSelected = false
                                    viewModel.isPasswordTFSelected = true
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
                        .foregroundStyle(Color(uiColor: viewModel.isPasswordTFSelected ? .label : .systemGray2))
                    
                    Button {
                        Task {
                            do {
                                try await viewModel.signUp()
                                viewModel.isProfileViewPresenting.toggle()
                                return
                            } catch {
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        HStack {
                            Text("Зарегистрироваться")
                            
                            Image(systemName: "arrow.right")
                        }
                        .foregroundStyle(
                            Color(
                                uiColor: viewModel.isEmailEntered && viewModel.isPasswordEntered && viewModel.isNameEntered ? .label : .gray
                            )
                        )
                        .font(.title2)
                        .fontDesign(.monospaced)
                        .padding(.top, 20)
                    }
                    .disabled(viewModel.isDataEntered())
                    
                    Spacer()
                    
                    Text("Войти")
                        .font(.title3)
                        .fontDesign(.monospaced)
                        .underline()
                        .foregroundStyle(Color.blue)
                        .padding(.bottom, 20)
                        .onTapGesture {
                            isScreenPresenting.toggle()
                    }
                }
                .onChange(of: viewModel.isProfileViewPresenting, { oldValue, newValue in
                    if newValue {
                        viewModel.nameText = ""
                        viewModel.emailText = ""
                        viewModel.passwordText = ""
                        
                        viewModel.isNameTFSelected = false
                        viewModel.isEmailTFSelected = false
                        viewModel.isPasswordTFSelected = false
                    }
                })
                .navigationDestination(isPresented: $viewModel.isProfileViewPresenting) {
                    ProfileView(isPresenting: $viewModel.isProfileViewPresenting)
                }
            }
        }
    }
}

#Preview {
    SignUpView(isScreenPresenting: .constant(true))
}
