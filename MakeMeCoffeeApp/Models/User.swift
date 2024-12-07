import Foundation

struct User: Identifiable, Codable {
    var id: String
    var email: String
    var name: String
    var photoURL: String?
    var favoriteItems: [String] // ID's любимых напитков
    
    init(id: String = UUID().uuidString, email: String, name: String, photoURL: String? = nil) {
        self.id = id
        self.email = email
        self.name = name
        self.photoURL = photoURL
        self.favoriteItems = []
    }
} 