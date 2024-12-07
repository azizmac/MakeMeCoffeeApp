//
//  ContentView.swift
//  MakeMeCoffeeApp
//
//  Created by Илья Моторин on 04.12.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var cartManager = CartManager()
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                TabView {
                    MenuView()
                        .tabItem {
                            Label("Меню", systemImage: "cup.and.saucer.fill")
                        }
                    
                    CartView()
                        .tabItem {
                            Label("Корзина", systemImage: "cart.fill")
                        }
                        .badge(cartManager.items.count)
                    
                    ProfileView()
                        .tabItem {
                            Label("Профиль", systemImage: "person.fill")
                        }
                }
            } else {
                AuthView()
            }
        }
        .environmentObject(authViewModel)
        .environmentObject(cartManager)
    }
}

#Preview {
    ContentView()
}
