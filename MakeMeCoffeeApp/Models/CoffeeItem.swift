import Foundation

struct CoffeeItem: Identifiable, Codable {
    var id: String
    var name: String
    var description: String
    var price: Double
    var imageURL: String?
    var category: Category
    
    enum Category: String, Codable, CaseIterable {
        case coffee = "Кофе"
        case tea = "Чай"
        case dessert = "Десерты"
        case snack = "Закуски"
    }
} 