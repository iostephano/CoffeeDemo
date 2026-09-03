//
//  MenuNavigatorTests.swift
//  CoffeeDemoTests
//
//  Created by Stephano Portella on 03/09/26.
//

import Testing
@testable import CoffeeDemo

struct MenuNavigatorTests {

    @Test("A fresh navigator starts on the first item")
    func startsAtFirst() {
        let navigator = MenuNavigator(items: [10, 20, 30])
        #expect(navigator.index == 0)
        #expect(navigator.current == 10)
    }

    @Test("next advances and wraps around to the start")
    func nextWraps() {
        var navigator = MenuNavigator(items: [10, 20, 30])
        navigator.next()
        #expect(navigator.current == 20)
        navigator.next()
        #expect(navigator.current == 30)
        navigator.next()
        #expect(navigator.current == 10)
    }

    @Test("previous goes back and wraps around to the end")
    func previousWraps() {
        var navigator = MenuNavigator(items: [10, 20, 30])
        navigator.previous()
        #expect(navigator.current == 30)
        navigator.previous()
        #expect(navigator.current == 20)
    }

    @Test("next then previous returns to where it started")
    func nextThenPreviousIsIdentity() {
        var navigator = MenuNavigator(items: [10, 20, 30], startingAt: 1)
        navigator.next()
        navigator.previous()
        #expect(navigator.index == 1)
    }

    @Test("An out-of-range start index is clamped into the list")
    func startIndexIsClamped() {
        #expect(MenuNavigator(items: [1, 2, 3], startingAt: 99).index == 2)
        #expect(MenuNavigator(items: [1, 2, 3], startingAt: -5).index == 0)
    }

    @Test("An empty navigator never crashes and has no current item")
    func emptyIsSafe() {
        var navigator = MenuNavigator(items: [Int]())
        #expect(navigator.current == nil)
        navigator.next()
        navigator.previous()
        #expect(navigator.index == 0)
        #expect(navigator.current == nil)
    }
}

struct CoffeeMenuTests {

    @Test("The menu has four drinks")
    func menuCount() {
        #expect(CoffeeItem.menu.count == 4)
    }

    @Test("Every drink points to a distinct .usdz file")
    func fileNamesAreDistinctUSDZ() {
        let names = CoffeeItem.menu.map(\.fileName)
        #expect(Set(names).count == names.count)
        #expect(names.allSatisfy { $0.hasSuffix(".usdz") })
    }

    @Test("Every drink has a title, a price and at least one ingredient")
    func drinksAreComplete() {
        for drink in CoffeeItem.menu {
            #expect(!drink.title.isEmpty)
            #expect(!drink.price.isEmpty)
            #expect(!drink.ingredients.isEmpty)
        }
    }

    @Test("A drink's id is its file name, so it is stable")
    func idIsFileName() {
        let drink = CoffeeItem.menu[0]
        #expect(drink.id == drink.fileName)
    }
}
