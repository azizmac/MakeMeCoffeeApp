import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showingEditName = false
    @State private var newName = ""
    
    var body: some View {
        NavigationStack {
            List {
                // Секция профиля
                Section {
                    HStack(spacing: 16) {
                        // Фото профиля
                        ProfileImageView(photoURL: authViewModel.currentUser?.photoURL)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color(.systemGray5), lineWidth: 1)
                            )
                            .onTapGesture {
                                showImagePicker = true
                            }
                        
                        // Информация пользователя
                        VStack(alignment: .leading, spacing: 4) {
                            if let user = authViewModel.currentUser {
                                Text(user.name)
                                    .font(.headline)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: { showingEditName = true }) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.tint)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Секция настроек
                Section {
                    NavigationLink(destination: OrderHistoryView()) {
                        Label("История заказов", systemImage: "clock.arrow.circlepath")
                    }
                    
                    NavigationLink(destination: FavoriteDrinksView()) {
                        Label("Любимые напитки", systemImage: "heart.fill")
                    }
                    
                    NavigationLink(destination: NotificationsSettingsView()) {
                        Label("Уведомления", systemImage: "bell.fill")
                    }
                }
                
                // Секция приложения
                Section {
                    NavigationLink(destination: AboutView()) {
                        Label("О приложении", systemImage: "info.circle.fill")
                    }
                    
                    Link(destination: URL(string: "https://makemecoffee.app/support")!) {
                        Label("Поддержка", systemImage: "questionmark.circle.fill")
                    }
                }
                
                // Кнопка выхода
                Section {
                    Button(role: .destructive, action: {
                        authViewModel.signOut()
                    }) {
                        Label("Выйти", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Профиль")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) { newImage in
                if let image = newImage {
                    authViewModel.updateProfilePhoto(image)
                }
            }
            .alert("Изменить имя", isPresented: $showingEditName) {
                TextField("Новое имя", text: $newName)
                Button("Отмена", role: .cancel) { }
                Button("Сохранить") {
                    // Здесь будет логика обновления имени
                }
            }
        }
    }
}

// Компонент для отображения фото профиля
struct ProfileImageView: View {
    let photoURL: String?
    
    var body: some View {
        Group {
            if let photoURL = photoURL,
               let url = URL(string: photoURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.tint)
            }
        }
    }
}

// Заглушки для дополнительных view
struct OrderHistoryView: View {
    var body: some View {
        Text("История заказов")
            .navigationTitle("История заказов")
    }
}

struct FavoriteDrinksView: View {
    var body: some View {
        Text("Любимые напитки")
            .navigationTitle("Любимые напитки")
    }
}

struct NotificationsSettingsView: View {
    var body: some View {
        Text("Настройки уведомлений")
            .navigationTitle("Уведомления")
    }
}

struct AboutView: View {
    var body: some View {
        List {
            Section {
                LabeledContent("Версия", value: "1.0.0")
                LabeledContent("Сборка", value: "1")
            }
            
            Section {
                Link("Политика конфиденциальности", destination: URL(string: "https://makemecoffee.app/privacy")!)
                Link("Условия использования", destination: URL(string: "https://makemecoffee.app/terms")!)
            }
        }
        .navigationTitle("О приложении")
    }
} 