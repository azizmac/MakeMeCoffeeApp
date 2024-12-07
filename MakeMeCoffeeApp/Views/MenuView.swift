import SwiftUI

struct MenuView: View {
    @StateObject private var menuViewModel = MenuViewModel()
    @State private var selectedCategory: CoffeeItem.Category = .coffee
    @Environment(\.colorScheme) var colorScheme
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    CategorySelector(
                        selectedCategory: $selectedCategory,
                        categories: CoffeeItem.Category.allCases
                    )
                    
                    MenuItemsGrid(
                        items: menuViewModel.items,
                        selectedCategory: selectedCategory
                    )
                }
            }
            .navigationTitle("Make Me Coffee")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.black)
        }
        .task {
            await menuViewModel.fetchItems()
        }
    }
}

// Оптимизированный селектор категорий
private struct CategorySelector: View {
    @Binding var selectedCategory: CoffeeItem.Category
    let categories: [CoffeeItem.Category]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    CategoryButton(
                        title: category.rawValue,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// Оптимизированная сетка товаров
private struct MenuItemsGrid: View {
    let items: [CoffeeItem]
    let selectedCategory: CoffeeItem.Category
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var filteredItems: [CoffeeItem] {
        items.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(filteredItems) { item in
                MenuItemCard(item: item)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .padding(.horizontal)
        .animation(.spring(response: 0.35, dampingFraction: 0.65), value: selectedCategory)
    }
}

// Оптимизированная карточка товара
private struct MenuItemCard: View {
    let item: CoffeeItem
    @State private var isPressed = false
    @EnvironmentObject private var cartManager: CartManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            MenuItemImage(imageURL: item.imageURL)
            MenuItemInfo(item: item, isPressed: $isPressed, onAdd: {
                cartManager.addToCart(item)
            })
        }
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.medium)
                .fill(AppTheme.Colors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radius.medium)
                        .stroke(AppTheme.Colors.cardBorder, lineWidth: 1)
                )
                .shadow(color: AppTheme.Colors.Card.shadow, radius: 10, x: 0, y: 5)
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.medium))
    }
}

// Оптимизированное изображение товара
private struct MenuItemImage: View {
    let imageURL: String?
    
    var body: some View {
        Group {
            if let imageURL = imageURL,
               let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.white.opacity(0.1)
                }
            } else {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.1))
            }
        }
        .frame(height: 140)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// Оптимизированная информация о товаре
private struct MenuItemInfo: View {
    let item: CoffeeItem
    @Binding var isPressed: Bool
    let onAdd: () -> Void
    
    private var formattedPrice: String {
        String(format: "%.0f ₽", item.price)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.name)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(item.description)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(2)
            
            HStack {
                Text(formattedPrice)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                AddButton(isPressed: $isPressed, onAdd: onAdd)
            }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
    }
}

// Оптимизированная кнопка добавления
private struct AddButton: View {
    @Binding var isPressed: Bool
    let onAdd: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
                onAdd()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }) {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
                .foregroundColor(.white)
        }
        .scaleEffect(isPressed ? 0.8 : 1)
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color.clear)
                .foregroundColor(isSelected ? .white : .accentColor)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.accentColor, lineWidth: 1)
                )
        }
        .buttonStyle(SpringyButton())
    }
}

// Пружинистая анимация для кнопок
struct SpringyButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
} 