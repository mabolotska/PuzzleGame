//
//  AsyncImageView.swift
//  PuzzleGame
//
//  Created by Maryna Bolotska on 18/11/24.
//

import SwiftUI
import Combine

struct AsyncImageView: View {

    @StateObject private var imageLoader = AsyncImageLoader()

    private let url: String
    private let placeholder: AnyView?
    private let loadingView: AnyView?

    init(
        url: String,
        @ViewBuilder placeholder: () -> (any View)? = { nil },
        @ViewBuilder loadingView: () -> (any View)? = { nil }
    ) {
        self.url = url
        if let placeholderView = placeholder() {
            self.placeholder = AnyView(placeholderView)
        } else {
            self.placeholder = nil
        }
        if let loadingViewView = loadingView() {
            self.loadingView = AnyView(loadingViewView)
        } else {
            self.loadingView = nil
        }
    }

    var body: some View {
        VStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if imageLoader.isLoading,
                      let loadingView {
                loadingView
            } else if imageLoader.image == nil,
                      let placeholder = placeholder {
                placeholder
            }
        }
        .onAppear {
     //       imageLoader.loadImage(from: url)
        }
    }
}

class AsyncImageLoader: ObservableObject {

    @Published private(set) var image: UIImage? = nil
    @Published private(set) var isLoading = false
    private let url = "https://picsum.photos/1024"
    private var cancellables = Set<AnyCancellable>()

    func loadImage() {
        guard let imageUrl = URL(string: url) else {
            return
        }
        isLoading = true
        URLSession.shared
            .dataTaskPublisher(for: imageUrl)
            .map {
                UIImage(data: $0.data)
            }
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .sink { [weak self] in
                self?.image = $0
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}
