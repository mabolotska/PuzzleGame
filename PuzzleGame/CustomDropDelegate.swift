import SwiftUI

struct CustomDropDelegate: DropDelegate {
    let currentItem: Item
    let segments: [Item]
    @Binding var shuffledSegments: [Item]
    @Binding var draggedItem: Item?
    let checkAndMarkPlacement: () -> Void
    let checkWinCondition: () -> Void
    
    func performDrop(info: DropInfo) -> Bool {
        guard let dItem = draggedItem, dItem != currentItem else { return false }
        
        // Find indices of dragged and current items
        if let fromIndex = shuffledSegments.firstIndex(of: dItem),
           let toIndex = shuffledSegments.firstIndex(of: currentItem) {
            
            // Perform the swap
            shuffledSegments.swapAt(fromIndex, toIndex)
            checkAndMarkPlacement()
            checkWinCondition()
        }
        draggedItem = nil
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
}
