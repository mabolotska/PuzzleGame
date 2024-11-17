////
////  workingvariant.swift
////  PuzzleGame
////
////  Created by Maryna Bolotska on 17/11/24.
////
//


import SwiftUI
import UniformTypeIdentifiers

struct DragAndDropView: View {
    struct Item: Identifiable, Hashable {
           let id = UUID() // Unique identifier for each item
           let image: UIImage
       }

       @State private var rectangles: [Item] = [
           Item(image: UIImage(named: "food")!),
           Item(image: UIImage(named: "test")!),
           Item(image: UIImage(named: "user")!),
           Item(image: UIImage(named: "food")!),
           Item(image: UIImage(named: "test")!),
           Item(image: UIImage(named: "user")!),
           Item(image: UIImage(named: "food")!),
           Item(image: UIImage(named: "test")!),
           Item(image: UIImage(named: "user")!)
       ]
    @State private var draggedItem: Item?

    let gridColumns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: gridColumns, spacing: 16) {
            ForEach(rectangles) { item in
                Image(uiImage: item.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .onDrag {
                        self.draggedItem = item
                        return NSItemProvider(object: item.image)
                    }
                    .onDrop(of: [UTType.image], delegate: CustomDropDelegate(
                        currentItem: item,
                        items: $rectangles,
                        draggedItem: $draggedItem
                    ))
            }
        }
        .padding()
    }
}

// MARK: - Custom Drop Delegate
struct CustomDropDelegate: DropDelegate {
    let currentItem: DragAndDropView.Item
    @Binding var items: [DragAndDropView.Item]
    @Binding var draggedItem: DragAndDropView.Item?

    func dropEntered(info: DropInfo) {

    }

    func performDrop(info: DropInfo) -> Bool {
        guard let dItem = draggedItem, dItem != currentItem else { return false }

        // Find indices of dragged item and current item
        if let fromIndex = items.firstIndex(of: dItem),
           let toIndex = items.firstIndex(of: currentItem) {
            // Swap items
         //   withAnimation {
                items.swapAt(fromIndex, toIndex)
         //   }
            
           
        }
        draggedItem = nil
        return true
       
    }

    func validateDrop(info: DropInfo) -> Bool {
        return true
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func dropExited(info: DropInfo) {
        // No action required
    }
}




// MARK: - Transferable for Int
extension Int: @retroactive Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .plainText)
    }
}

//struct DragAndDropView: View {
//    @State private var rectangles = Array(1...9) // Create 9 rectangles numbered 1 to 9
//    @State private var draggedItem: Int?
//
//    let gridColumns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
//
//    var body: some View {
//        LazyVGrid(columns: gridColumns, spacing: 16) {
//            ForEach(rectangles, id: \.self) { number in
//                Rectangle()
//                    .fill(Color.blue)
//                    .frame(height: 100)
//                    .overlay(Text("\(number)").foregroundColor(.white).font(.headline))
//                    .onDrag {
//                        draggedItem = number
//                        return NSItemProvider(object: "\(number)" as NSString)
//                    }
//                    .onDrop(of: [UTType.plainText], delegate: CustomDropDelegate(
//                        currentItem: number,
//                        items: $rectangles,
//                        draggedItem: $draggedItem
//                    ))
//            }
//        }
//        .padding()
//    }
//}
//
//// MARK: - Custom Drop Delegate
//struct CustomDropDelegate: DropDelegate {
//    let currentItem: Int
//    @Binding var items: [Int]
//    @Binding var draggedItem: Int?
//
//    func dropEntered(info: DropInfo) {
//
//    }
//
//    func performDrop(info: DropInfo) -> Bool {
//        guard let dItem = draggedItem, dItem != currentItem else { return false }
//
//        // Find indices of dragged item and current item
//        if let fromIndex = items.firstIndex(of: dItem),
//           let toIndex = items.firstIndex(of: currentItem) {
//            // Swap items
//         //   withAnimation {
//                items.swapAt(fromIndex, toIndex)
//         //   }
//            
//           
//        }
//        draggedItem = nil
//        return true
//       
//    }
//
//    func validateDrop(info: DropInfo) -> Bool {
//        return true
//    }
//
//    func dropUpdated(info: DropInfo) -> DropProposal? {
//        return DropProposal(operation: .move)
//    }
//
//    func dropExited(info: DropInfo) {
//        // No action required
//    }
//}
//
//
//
//
//// MARK: - Transferable for Int
//extension Int: @retroactive Transferable {
//    public static var transferRepresentation: some TransferRepresentation {
//        CodableRepresentation(contentType: .plainText)
//    }
//}

////it works but not good
//
//import SwiftUI
//
//import SwiftUI
//
//import SwiftUI
//import UniformTypeIdentifiers
//
//struct DragAndDropView: View {
//    @State private var rectangles = Array(1...9) // Create 9 rectangles numbered 1 to 9
//    @State private var draggedItem: Int?
//
//    let gridColumns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
//
//    var body: some View {
//        LazyVGrid(columns: gridColumns, spacing: 16) {
//            ForEach(rectangles, id: \.self) { number in
//                Rectangle()
//                    .fill(Color.blue)
//                    .frame(height: 100)
//                    .overlay(Text("\(number)").foregroundColor(.white).font(.headline))
////                    .draggable(number) { // Enable drag
////                        draggedItem = number // Set the dragged item when drag starts
////                    }
//                    .onDrag {
//                                            draggedItem = number // Set the dragged item when drag starts
//                                            return NSItemProvider(object: String(number) as NSString)
//                                        }
//                    .onDrop(of: [UTType.plainText], delegate: CustomDropDelegate(
//                        currentItem: number,
//                        items: $rectangles,
//                        draggedItem: $draggedItem
//                    ))
//            }
//        }
//        .padding()
//    }
//}
//
//// MARK: - Custom Drop Delegate
//struct CustomDropDelegate: DropDelegate {
//    let currentItem: Int
//    @Binding var items: [Int]
//    @Binding var draggedItem: Int?
//
//    func dropEntered(info: DropInfo) {
//        guard let draggedItem = draggedItem, // Ensure there is a dragged item
//              let fromIndex = items.firstIndex(of: draggedItem), // Get index of dragged item
//              let toIndex = items.firstIndex(of: currentItem) // Get index of target item
//        else {
//            return
//        }
//
//        if fromIndex != toIndex {
//            // Swap the items
//       //     withAnimation {
//                items.swapAt(fromIndex, toIndex)
//     //       }
//            self.draggedItem = currentItem // Update the dragged item to reflect the new position
//        }
//    }
//
//    func validateDrop(info: DropInfo) -> Bool {
//        draggedItem != nil
//    }
//
//    func performDrop(info: DropInfo) -> Bool {
//        draggedItem = nil // Clear the dragged item after the drop is complete
//        return true
//    }
//
//    func dropUpdated(info: DropInfo) -> DropProposal? {
//        DropProposal(operation: .move)
//    }
//
//    func dropExited(info: DropInfo) {
//        // No action required
//    }
//}
//
//
//
//import SwiftUI
//import UniformTypeIdentifiers
//
//extension Int: @retroactive Transferable {
//    public static var transferRepresentation: some TransferRepresentation {
//        CodableRepresentation(contentType: .plainText)
//    }
//}
