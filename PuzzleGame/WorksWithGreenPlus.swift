//
//  WorksWithGreenPlus.swift
//  PuzzleGame
//
//  Created by Maryna Bolotska on 17/11/24.
//

import SwiftUI

struct DView: View {
    @State private var rectangles = Array(1...9) // Create 9 rectangles numbered 1 to 9
    @State private var draggedItem: Int?

    let gridColumns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: gridColumns, spacing: 16) {
            ForEach(rectangles, id: \.self) { number in
                Rectangle()
                    .fill(Color.blue)
                    .frame(height: 100)
                    .overlay(Text("\(number)").foregroundColor(.white).font(.headline))
                    .draggable(number) // Make the rectangle draggable
                    .dropDestination(for: Int.self) { items, location in
                        guard let draggedNumber = items.first,
                              let fromIndex = rectangles.firstIndex(of: draggedNumber),
                              let toIndex = rectangles.firstIndex(of: number)
                        else {
                            return false
                        }

                        // Swap the items
                        rectangles.swapAt(fromIndex, toIndex)
                        return true
                    }
            }
        }
        .padding()
    }
}
