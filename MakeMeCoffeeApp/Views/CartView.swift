import SwiftUI

struct CartView: View {
    @EnvironmentObject private var cartManager: CartManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                Group {
                    if cartManager.items.isEmpty {
                        EmptyCartView()
                    } else {
                        CartContentView(items: cartManager.items, total: cartManager.total)
                    }
                }
                .animation(.easeInOut, value: cartManager.items.isEmpty)
            }
            .navigationTitle("Корзина")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

// Выносим пустое состояние в отдельное view для оптимизации
private struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 64))
                .foregroundStyle(.white.opacity(0.7))
                .padding(.bottom, 8)
            
            Text("Корзина пуста")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("Добавьте что-нибудь из меню")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
        }
    }
}

// Выносим основной контент в отдельное view
private struct CartContentView: View {
    let items: [CartItem]
    let total: Double
    @EnvironmentObject private var cartManager: CartManager
    
    var body: some View {
        VStack(spacing: 0) {
            CartItemsList(items: items)
            CartFooter(total: total)
        }
    }
}

// Оптимизированный список товаров
private struct CartItemsList: View {
    let items: [CartItem]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(items) { item in
                    CartItemCard(item: item)
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            .padding()
        }
    }
}

// Оптимизированная карточка товара
private struct CartItemCard: View {
    @EnvironmentObject private var cartManager: CartManager
    let item: CartItem
    
    private var formattedPrice: String {
        String(format: "%.0f ₽", item.coffeeItem.price)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            CartItemImage(imageURL: item.coffeeItem.imageURL)
            CartItemInfo(item: item, formattedPrice: formattedPrice)
            
            Spacer()
            
            DeleteButton(action: {
                withAnimation {
                    cartManager.removeFromCart(item)
                }
            })
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                .fill(AppTheme.Colors.Gradient.purple.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                        .stroke(AppTheme.Colors.cardBorder, lineWidth: 1)
                )
        )
        .shadow(color: AppTheme.Colors.Card.shadow, radius: 8)
    }
}

// Оптимизированное изображение товара
private struct CartItemImage: View {
    let imageURL: String?
    
    var body: some View {
        Group {
            if let imageURL = imageURL,
               let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.white.opacity(0.1)
                }
            } else {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.opacity(0.1))
            }
        }
        .frame(width: 80, height: 80)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// Оптимизированная информация о товаре
private struct CartItemInfo: View {
    @EnvironmentObject private var cartManager: CartManager
    let item: CartItem
    let formattedPrice: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.coffeeItem.name)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(formattedPrice)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
            
            QuantityControl(item: item)
        }
    }
}

// Выносим контроллер количества
private struct QuantityControl: View {
    @EnvironmentObject private var cartManager: CartManager
    let item: CartItem
    
    var body: some View {
        HStack(spacing: 16) {
            QuantityButton(icon: "minus", isAddition: false, item: item)
            
            Text("\(item.quantity)")
                .font(.headline)
                .monospacedDigit()
                .foregroundColor(.white)
            
            QuantityButton(icon: "plus", isAddition: true, item: item)
        }
    }
}

// Оптимизированная кнопка изменения количества
private struct QuantityButton: View {
    @EnvironmentObject private var cartManager: CartManager
    let icon: String
    let isAddition: Bool
    let item: CartItem
    
    var body: some View {
        Button(action: {
            if isAddition {
                cartManager.updateQuantity(for: item, quantity: item.quantity + 1)
            } else if item.quantity > 1 {
                cartManager.updateQuantity(for: item, quantity: item.quantity - 1)
            } else {
                cartManager.removeFromCart(item)
            }
        }) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(isAddition ? .black : .white)
                .frame(width: 28, height: 28)
                .background(isAddition ? Color.white : Color.white.opacity(0.1))
                .clipShape(Circle())
        }
    }
}

// Оптимизированная кнопка удаления
private struct DeleteButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "trash")
                .font(.headline)
                .foregroundStyle(.red.opacity(0.8))
        }
    }
}

// Оптимизированная нижняя панель
private struct CartFooter: View {
    let total: Double
    
    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .frame(height: 1)
            
            VStack(spacing: 12) {
                OrderInfoRow(title: "Подытог", value: String(format: "%.0f ₽", total))
                OrderInfoRow(title: "Доставка", value: "Бесплатно")
                OrderInfoRow(title: "Итого", value: String(format: "%.0f ₽", total), isTotal: true)
            }
            .padding(.horizontal)
            
            CheckoutButton()
        }
        .background(CartFooterBackground())
    }
}

// Обновленная кнопка оплаты
private struct CheckoutButton: View {
    var body: some View {
        Button(action: {
            // Здесь будет обработка оплаты
        }) {
            Text("Оплатить")
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 56)
                .frame(maxWidth: .infinity)
                .background(
                    AppTheme.Colors.Gradient.blue
                )
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
                .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal)
        .padding(.bottom, 32)
    }
}

// Оптимизированный фон нижней панели
private struct CartFooterBackground: View {
    var body: some View {
        Color(UIColor.systemBackground)
            .opacity(0.03)
            .overlay(
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
    }
}

struct OrderInfoRow: View {
    let title: String
    let value: String
    var isTotal: Bool = false
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(isTotal ? .white : .white.opacity(0.7))
                .font(isTotal ? .headline : .subheadline)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.white)
                .font(isTotal ? .headline : .subheadline)
                .fontWeight(isTotal ? .bold : .regular)
        }
    }
} 