import Foundation

struct CartItem: Identifiable, Equatable {
    let id = UUID()
    let coffeeItem: CoffeeItem
    var quantity: Int
    
    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        lhs.id == rhs.id && 
        lhs.quantity == rhs.quantity &&
        lhs.coffeeItem.id == rhs.coffeeItem.id
    }
}

@MainActor
class CartManager: ObservableObject {
    @Published private(set) var items: [CartItem] = []
    @Published private(set) var total: Double = 0
    
    func addToCart(_ item: CoffeeItem) {
        if let index = items.firstIndex(where: { $0.coffeeItem.id == item.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(coffeeItem: item, quantity: 1))
        }
        calculateTotal()
    }
    
    func removeFromCart(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
        calculateTotal()
    }
    
    func updateQuantity(for item: CartItem, quantity: Int) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            if quantity <= 0 {
                items.remove(at: index)
            } else {
                items[index].quantity = quantity
            }
            calculateTotal()
        }
    }
    
    private func calculateTotal() {
        total = items.reduce(0) { $0 + ($1.coffeeItem.price * Double($1.quantity)) }
    }
} 