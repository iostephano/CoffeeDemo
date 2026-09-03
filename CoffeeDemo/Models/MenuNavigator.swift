//
//  MenuNavigator.swift
//  CoffeeDemo
//
//  Created by Stephano Portella on 03/09/26.
//

/// Recorre una lista de forma cíclica en ambos sentidos. Es un tipo de valor
/// puro: la vista lo tiene en `@State` y los tests lo ejercen directamente.
nonisolated struct MenuNavigator<Element>: Equatable, Sendable where Element: Equatable & Sendable {

    let items: [Element]
    private(set) var index: Int

    init(items: [Element], startingAt index: Int = 0) {
        self.items = items
        self.index = items.isEmpty ? 0 : index.clamped(to: 0...(items.count - 1))
    }

    var current: Element? {
        items.indices.contains(index) ? items[index] : nil
    }

    mutating func next() {
        guard !items.isEmpty else { return }
        index = (index + 1) % items.count
    }

    mutating func previous() {
        guard !items.isEmpty else { return }
        index = (index - 1 + items.count) % items.count
    }
}

private extension Comparable {
    nonisolated func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
