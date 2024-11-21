import SwiftUI

class ImageDownloader: ObservableObject {
    @Published var image: UIImage? = nil
    private let url = "https://picsum.photos/1024"
    @Published private(set) var isLoading = false
    
    func fetchImage() {
        guard let imageUrl = URL(string: url) else {
            fallbackToTestImage()
            return
        }
        isLoading = true
        
        URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil,
                  let downloadedImage = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    self?.fallbackToTestImage()
                    
                }
                return
            }
            
            DispatchQueue.main.async {
                self.image = downloadedImage
                self.isLoading = false
            }
        }.resume()
    }
    
    private func fallbackToTestImage() {
        self.image = UIImage(named: "test")
    }
}
