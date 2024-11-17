//
//  TestIm.swift
//  PuzzleGame
//
//  Created by Maryna Bolotska on 16/11/24.
//



import SwiftUI
import UniformTypeIdentifiers
struct ContenView: View {
    struct Item: Identifiable, Hashable {
        let id = UUID()
        let image: UIImage
        var correctlyPlaced: Bool = false
    }
    
    

    @State private var segments: [Item] = []
    @State private var shuffledSegments: [Item] = []
    @State private var draggedItem: Item?
    let image = UIImage(named: "user") ?? UIImage(systemName: "photo")!
    let gridSize = 3

    var body: some View {
        VStack {
           
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: gridSize), spacing: 10) {
                ForEach(shuffledSegments) { item in
                    
                    Image(uiImage: item.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                        .overlay(Rectangle().stroke(Color.gray, lineWidth: 1))
                        .onDrag {
                            if item.correctlyPlaced {
                                                            return NSItemProvider() // Return an empty NSItemProvider to prevent dragging
                                                        }
                            self.draggedItem = item
                            return NSItemProvider(object: item.image)
                        }
//                    preview: {
//                            // Disable preview if the item is correctly placed
//                            if item.correctlyPlaced {
//                                AnyView(EmptyView()) // Return an empty view for no preview
//                            }
//                        Image(uiImage: item.image) // Normal preview when the item is draggable
//                        }
                        .onDrop(of: [UTType.image], delegate: NewCustomDropDelegate(
                            currentItem: item,
                            items: $shuffledSegments,
                            draggedItem: $draggedItem, segments: segments, // Pass the original segments
                            action: { handleTapGesture(for: item) }
                            ))
                        
                }
            }
            .padding()
        }
        .onAppear {
            segments = splitImage(image, into: gridSize)
            shuffledSegments = segments.shuffled() // Shuffle the segments
            
        }
    }

    func splitImage(_ image: UIImage, into gridSize: Int) -> [Item] {
        guard let cgImage = image.cgImage else {
            print("Failed to get CGImage from UIImage.")
            return []
        }
        let width = cgImage.width / gridSize
        let height = cgImage.height / gridSize
        
        var segments: [Item] = []
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let rect = CGRect(x: col * width, y: row * height, width: width, height: height)
                if let croppedCGImage = cgImage.cropping(to: rect) {
                    let segmentImage = UIImage(cgImage: croppedCGImage)
                    let segment = Item(image: segmentImage) // Create an 'Item' with the cropped image
                    segments.append(segment)
                } else {
                    print("Failed to crop image at row: \(row), col: \(col)")
                }
            }
        }
        print("Number of segments created: \(segments.count)")
        return segments
    }
    
    func compareArrays() {
        // Check if all items in shuffledSegments are in the same order as in segments
//        let isWinner = shuffledSegments.enumerated().allSatisfy { index, shuffledItem in
//            // Find the original index of the shuffled item
//            if let originalIndex = segments.firstIndex(where: { $0.id == shuffledItem.id }) {
//                return originalIndex == index // Check if indices match
//            }
//            return false
//        }
//        
//        if isWinner {
//            print("You are winner")
//        } else {
//            print("Keep trying!")
//        }
        
    }
    
    func handleTapGesture(for item: Item) {
   //         Get index of the tapped item in shuffledSegments
//           if let shuffledIndex = shuffledSegments.firstIndex(where: { $0.id == item.id }),
//              let originalIndex = segments.firstIndex(where: { $0.id == item.id }) {
//               if originalIndex == shuffledIndex {
//                   print("Correct position!")
//               }
//               print("Tapped  index: \(originalIndex), shuffled index: \(shuffledIndex)")
//           }
       }


}


struct NewCustomDropDelegate: DropDelegate {
    let currentItem: ContenView.Item
    @Binding var items: [ContenView.Item]
    @Binding var draggedItem: ContenView.Item?
    let segments: [ContenView.Item] // Pass the original segments
    let action: () -> Void

    func performDrop(info: DropInfo) -> Bool {
        guard let dItem = draggedItem, dItem != currentItem else { return false }

        // Find indices of dragged and current items
        if let fromIndex = items.firstIndex(of: dItem),
           let toIndex = items.firstIndex(of: currentItem) {
            
            // Perform the swap
            items.swapAt(fromIndex, toIndex)

            // After the swap, recompute the shuffled and original indices
            if let shuffledIndex = items.firstIndex(of: dItem),
               let originalIndex = segments.firstIndex(where: { $0.id == dItem.id }) {
                if shuffledIndex == originalIndex {
                    if let index = items.firstIndex(where: { $0.id == dItem.id }) {
                                           items[index].correctlyPlaced = true
                                       }
                }
            }
        }

        // Schedule any post-drop actions
        DispatchQueue.main.async {
            action() // Ensures handleTapGesture runs with updated state
        }

        draggedItem = nil
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
           return DropProposal(operation: .move)
       }

}
