//
//  PuzzleMainViewModel.swift
//  PuzzleGame
//
//  Created by Maryna Bolotska on 18/11/24.
//

import SwiftUI
import Combine
import Network

class ViewModel: ObservableObject {
    @Published var segments: [Item] = []
    @Published var shuffledSegments: [Item] = []
    @Published var draggedItem: Item?
    @Published var image: UIImage?
    @Published var isLoading = false
    private let placeholder = UIImage(named: "test")
    let gridSize = 3
    private let imageLoader = AsyncImageLoader()
    private var cancellables = Set<AnyCancellable>()
    
    func loadImage() {
        isLoading = true
        imageLoader.loadImage()
        imageLoader.$image
            .compactMap { $0 }
            .first()
            .sink { [weak self] downloadedImage in
                self?.isLoading = false
                self?.image = downloadedImage
                self?.prepareSegments(from: downloadedImage)
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
}
