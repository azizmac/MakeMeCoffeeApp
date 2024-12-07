import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isLogin = true
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Логотип и заголовок
                    VStack(spacing: 12) {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(AppTheme.Colors.Gradient.purple)
                            .rotationEffect(.degrees(isAnimating ? 360 : 0))
                            .animation(
                                .spring(response: 0.5, dampingFraction: 0.5)
                                .repeatForever(autoreverses: false),
                                value: isAnimating
                            )
                        
                        Text("Make Me Coffee")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(AppTheme.Colors.primaryText)
                            .opacity(isAnimating ? 1 : 0)
                            .offset(y: isAnimating ? 0 : 20)
                        
                        Text("Кофе с собой")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                            .opacity(isAnimating ? 1 : 0)
                            .offset(y: isAnimating ? 0 : 20)
                    }
                    .padding(.top, 40)
                    
                    // Форма входа
                    VStack(spacing: 16) {
                        AuthTextField(
                            icon: "envelope",
                            placeholder: "Email",
                            text: $email
                        )
                        
                        AuthTextField(
                            icon: "lock",
                            placeholder: "Пароль",
                            text: $password,
                            isSecure: true
                        )
                    }
                    .padding(.horizontal)
                    
                    // Кнопки
                    VStack(spacing: 16) {
                        Button(action: {
                            withAnimation {
                                if isLogin {
                                    authViewModel.login(email: email, password: password)
                                } else {
                                    authViewModel.register(email: email, password: password)
                                }
                            }
                        }) {
                            Text(isLogin ? "Войти" : "Зарегистрироваться")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(AppTheme.Colors.Gradient.blue)
                                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
                                .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        
                        Button(action: {
                            withAnimation {
                                isLogin.toggle()
                            }
                        }) {
                            Text(isLogin ? "Нет аккаунта? Зарегистрируйтесь" : "Уже есть аккаунт? Войдите")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.Colors.Gradient.purple)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct AuthTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .frame(width: 24)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textContentType(.password)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.medium)
                .fill(AppTheme.Colors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radius.medium)
                        .stroke(AppTheme.Colors.cardBorder, lineWidth: 1)
                )
        )
        .foregroundColor(AppTheme.Colors.primaryText)
    }
} 