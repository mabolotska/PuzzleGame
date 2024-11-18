//
//  DownloadManager.swift
//  PuzzleGame
//
//  Created by Maryna Bolotska on 18/11/24.
//

import Combine
import SwiftUI

class DownloadManager {
    
    let imgUrl = URL(string: "https://picsum.photos/1024")!
    
    func downloadImageWithCombine() -> AnyPublisher <UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: imgUrl)
            .map { data, response in
                guard let gResponse = response as? HTTPURLResponse,
                      gResponse.statusCode >= 200 && gResponse.statusCode < 300,
                      let image = UIImage(data: data) else { return nil }
                
                return image
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
