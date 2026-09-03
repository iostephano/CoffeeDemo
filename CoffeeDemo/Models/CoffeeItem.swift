//
//  CoffeeItem.swift
//  CoffeeDemo
//
//  Created by Stephano Portella on 02/10/25.
//

import Foundation

/// Una bebida de la carta. `fileName` es el nombre del `.usdz` que la representa
/// en 3D (ver el README: los modelos no vienen en el repo).
nonisolated struct CoffeeItem: Identifiable, Equatable, Sendable {
    var id: String { fileName }

    let fileName: String
    let title: String
    let subtitle: String
    let ingredients: [String]
    let notes: String
    let price: String
}

extension CoffeeItem {
    static let menu: [CoffeeItem] = [
        CoffeeItem(
            fileName: "caffe_latte.usdz",
            title: "Caffè Latte",
            subtitle: "Espresso suave con leche cremosa",
            ingredients: ["Espresso doble", "Leche al vapor", "Espuma ligera"],
            notes: "Equilibrado y sedoso. Dulzor natural de la leche.",
            price: "€3.90"
        ),
        CoffeeItem(
            fileName: "Double_Hot_Chocolate.usdz",
            title: "Double Hot Chocolate",
            subtitle: "Cacao intenso, textura aterciopelada",
            ingredients: ["Leche", "Cacao 60%", "Sirope de chocolate", "Crema batida"],
            notes: "Cremoso, toque amargo balanceado con dulzor.",
            price: "€4.20"
        ),
        CoffeeItem(
            fileName: "Nutella_Milkshake.usdz",
            title: "Nutella Milkshake",
            subtitle: "Avellanas y cacao, versión helada",
            ingredients: ["Leche fría", "Helado de vainilla", "Nutella", "Hielo triturado", "Crema"],
            notes: "Dulce y goloso, ideal como postre bebible.",
            price: "€4.80"
        ),
        CoffeeItem(
            fileName: "vanilla_iced_latte.usdz",
            title: "Vanilla Iced Latte",
            subtitle: "Refrescante con vainilla natural",
            ingredients: ["Espresso", "Leche fría", "Hielo", "Jarabe de vainilla"],
            notes: "Aromático, dulzor medio para tardes calurosas.",
            price: "€4.50"
        )
    ]
}
