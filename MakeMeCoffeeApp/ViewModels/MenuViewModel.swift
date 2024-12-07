import SwiftUI

@MainActor
class MenuViewModel: ObservableObject {
    @Published private(set) var items: [CoffeeItem] = []
    @Published private(set) var isLoading = false
    @Published var error: Error?
    
    func fetchItems() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Имитация загрузки данных
            try await Task.sleep(nanoseconds: 500_000_000)
            items = [
                CoffeeItem(id: "1", name: "Капучино", description: "Классический капучино", price: 159.0, category: .coffee),
                CoffeeItem(id: "2", name: "Латте", description: "Кофе латте", price: 169.0, category: .coffee),
                CoffeeItem(id: "3", name: "Эспрессо", description: "Крепкий эспрессо", price: 129.0, category: .coffee),
                CoffeeItem(id: "4", name: "Зеленый чай", description: "Китайский зеленый чай", price: 119.0, category: .tea),
                CoffeeItem(id: "5", name: "Чизкейк", description: "Нью-Йорк чизкейк", price: 259.0, category: .dessert)
            ]
        } catch {
            self.error = error
        }
    }
} 
