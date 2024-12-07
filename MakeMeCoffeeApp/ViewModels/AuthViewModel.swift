import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    
    func login(email: String, password: String) {
        // Мок авторизации
        self.isAuthenticated = true
        self.currentUser = User(email: email, name: "Тестовый пользователь")
    }
    
    func register(email: String, password: String) {
        // Мок регистрации
        login(email: email, password: password)
    }
    
    func signOut() {
        self.isAuthenticated = false
        self.currentUser = nil
    }
    
    func updateProfilePhoto(_ image: UIImage) {
        // Мок обновления фото
        currentUser?.photoURL = "dummy_url"
    }
} 