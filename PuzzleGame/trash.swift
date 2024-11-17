//
//  trash.swift
//  PuzzleGame
//
//  Created by Maryna Bolotska on 17/11/24.
//

//struct DropView: View {
//    private var theImage: some View {
//        Image("test")
//            .resizable()
//            .scaledToFit()
//            .padding(20)
//            .frame(width: 300, height: 300)
//            .background(.yellow)
//    }
//
//    var body: some View {
//        VStack {
//            ForEach(0..<3, id: \.self) { row in
//                HStack {
//                    ForEach(0..<3, id: \.self) { col in
//                        theImage
//                            .offset(x: CGFloat(-100 * col), y: CGFloat(-100 * row))
//                            .frame(width: 100, height: 100, alignment: .topLeading)
//                            .clipShape(Rectangle())
//                    }
//                }
//            }
//        }
//    }
//
//}



//struct ContenView: View {
//    struct Item: Identifiable, Hashable {
//           let id = UUID() // Unique identifier for each item
//           let image: UIImage
//       }
//
//
//    let image = UIImage(named: "user") ?? UIImage(systemName: "photo")!
//    let gridSize = 3
//
//    var body: some View {
//        let segments: [UIImage] = splitImage(image, into: gridSize)
//
//        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: gridSize), spacing: 10) {
//            ForEach(segments.indices, id: \.self) { index in
//                Image(uiImage: segments[index])
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(height: 100) // Example frame size, adjust as needed
//                    .overlay(Rectangle().stroke(Color.gray, lineWidth: 1)) // Optional border for clarity
////                    .onDrag {
////                        // Return the image data as the drag item
////                        return NSItemProvider(object: UIImage(data: segments[index].pngData()!)!)
////                    }
////                    .onDrop(of: [UTType.image], isTargeted: nil) { providers in
////                        guard let item = providers.first else { return false }
////
////                        // Retrieve the dragged image
////                        item.loadObject(ofClass: UIImage.self) { (image, error) in
////                            guard let draggedImage = image as? UIImage else { return }
////
////                            // Find the index of the dragged image and the target index
////                            if let sourceIndex = segments.firstIndex(of: draggedImage) {
////                                // Swap the images
////                                swap(&segments[sourceIndex], &segments[index])
////                            }
////                        }
////                        return true
////                    }
//            }
//        }
//        .padding()
//    }
//
//    func splitImage(_ image: UIImage, into gridSize: Int) -> [UIImage] {
//        guard let cgImage = image.cgImage else {
//            print("Failed to get CGImage from UIImage.")
//            return []
//        }
//        let width = cgImage.width / gridSize
//        let height = cgImage.height / gridSize
//
//        var segments: [UIImage] = []
//
//        for row in 0..<gridSize {
//            for col in 0..<gridSize {
//                let rect = CGRect(x: col * width, y: row * height, width: width, height: height)
//                if let croppedCGImage = cgImage.cropping(to: rect) {
//                    let segment = UIImage(cgImage: croppedCGImage)
//                    segments.append(segment)
//                } else {
//                    print("Failed to crop image at row: \(row), col: \(col)")
//                }
//            }
//        }
//        print("Number of segments created: \(segments.count)")
//        return segments
//    }
//}
