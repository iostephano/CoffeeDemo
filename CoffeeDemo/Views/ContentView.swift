//
//  ContentView.swift
//  CoffeeDemo
//
//  Created by Stephano Portella on 02/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var navigator = MenuNavigator(items: CoffeeItem.menu)

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let item = navigator.current {
                CoffeeViewer3D(fileName: item.fileName)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
                        Text("Coffee Demo")
                            .font(.system(.largeTitle, design: .serif))
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.top, 14)
                    .padding(.horizontal, 16)

                    Spacer(minLength: 0)

                    CoffeeCard(
                        item: item,
                        onPrevious: { navigator.previous() },
                        onNext: { navigator.next() }
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
