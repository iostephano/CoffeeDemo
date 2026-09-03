//
//  CoffeeCard.swift
//  CoffeeDemo
//
//  Created by Stephano Portella on 02/10/25.
//

import SwiftUI

/// Tarjeta inferior con la ficha de la bebida y los controles prev/next.
struct CoffeeCard: View {
    let item: CoffeeItem
    let onPrevious: () -> Void
    let onNext: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(item.title)
                .font(.system(size: 22, weight: .bold))
            Text(item.subtitle)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)

            Divider().opacity(0.25)

            VStack(alignment: .leading, spacing: 6) {
                Text("Ingredientes").font(.system(size: 14, weight: .semibold))
                ForEach(item.ingredients, id: \.self) { ingredient in
                    HStack(alignment: .top, spacing: 8) {
                        Circle().frame(width: 4.5, height: 4.5).opacity(0.35)
                        Text(ingredient).font(.system(size: 13))
                    }
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Notas").font(.system(size: 14, weight: .semibold))
                Text(item.notes)
                    .font(.system(size: 13))
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack {
                Text(item.price)
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                Button(action: onPrevious) {
                    Image(systemName: "chevron.left").font(.title3.weight(.bold))
                }
                Button(action: onNext) {
                    Image(systemName: "chevron.right").font(.title3.weight(.bold))
                }
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
        }
        .padding(16)
        .foregroundStyle(.white)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
    }
}
