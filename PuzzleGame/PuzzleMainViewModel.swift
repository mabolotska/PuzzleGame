import SwiftUI
import Combine

class ViewModel: ObservableObject {
    @Published var segments: [Item] = []
    @Published var shuffledSegments: [Item] = []
    @Published var draggedItem: Item?
    @Published var image: UIImage?
    @Published var isLoading = false
    @Published var showWinAlert = false
    private let placeholder = UIImage(named: "test")
    let gridSize = 3
    private var cancellables = Set<AnyCancellable>()
    private var imageDownloader = ImageDownloader()
    
    func loadImage() {
        isLoading = true
        imageDownloader.fetchImage()
        imageDownloader.$image
            .sink { [weak self] downloadedImage in
                
                if let image = downloadedImage {
                    self?.image = image
                    self?.prepareSegments(from: image)
                    self?.isLoading = false
                }
            }
            .store(in: &cancellables)
    }
    
    
    private func prepareSegments(from image: UIImage) {
        segments = splitImage(image, into: gridSize)
        shuffledSegments = segments.shuffled()
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
    
    func equalSegmentsCheck() {
        shuffledSegments.indices.forEach { index in
            if let originalIndex = segments.firstIndex(where: { $0.id == shuffledSegments[index].id }),
               index == originalIndex {
                shuffledSegments[index].correctlyPlaced = true
            } else {
                shuffledSegments[index].correctlyPlaced = false
            }
        }
    }
    
    func checkIfPuzzleIsDone() {
        let isWin = segments.indices.allSatisfy { index in
            segments[index].id == shuffledSegments[index].id
        }
        
        if isWin {
            showWinAlert = true
        }
    }
}
