
import SwiftUI
import UniformTypeIdentifiers

struct Item: Identifiable, Hashable {
    let id = UUID()
    let image: UIImage
    var correctlyPlaced: Bool = false
}

struct PuzzleMainView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                
                ProgressView("Loading Image...")
                    .padding()
            } else {
                LazyVGrid(columns:
                            Array(repeating: GridItem(.flexible()),
                                  count: viewModel.gridSize),
                                  spacing: 3) {
                    ForEach(viewModel.shuffledSegments) { item in
                        Image(uiImage: item.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                            .overlay(Rectangle().stroke(Color.gray, lineWidth: 1))
                            .onDrag {
                                if item.correctlyPlaced {
                                    return NSItemProvider() // Prevent dragging
                                }
                                self.viewModel.draggedItem = item
                                return NSItemProvider(object: item.image)
                            }
                            .onDrop(of: [UTType.image], delegate: NewCustomDropDelegate(
                                currentItem: item,
                                segments: viewModel.segments,
                                shuffledSegments: $viewModel.shuffledSegments,
                                draggedItem: $viewModel.draggedItem,
                                checkAndMarkPlacement: viewModel.equalSegmentsCheck,
                                checkWinCondition: viewModel.checkIfPuzzleIsDone
                            ))
                    }
                }
                 .padding()
            }
        }
        .onAppear {
            viewModel.loadImage()
        }
        .alert(isPresented: $viewModel.showWinAlert) {
            Alert(
                title: Text("Congrats!"),
                message: Text("You completed this puzzle"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}


struct NewCustomDropDelegate: DropDelegate {
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
