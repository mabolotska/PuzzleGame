//
//  Test.swift
//  PuzzleGame
//
//  Created by Maryna Bolotska on 16/11/24.
import SwiftUI

struct UserProfilePhotoView: View {

    let profilePhotoURL: String?
    let photo: Image?
   

    init(
        profilePhotoURL: String?,
        photo: Image? = nil

    ) {
        self.profilePhotoURL = profilePhotoURL
        self.photo = photo
        
    }

    var body: some View {
        Group {
            if let photo {
                photo
                    .resizable()
                    .scaledToFit()
                    .clipShape(.circle)
            } else if let profilePhotoURL {
                AsyncImageView(
                    url: profilePhotoURL,
                    placeholder: {
                        avatarView()
                    }
                )
                .clipShape(.circle)
            } else {
                avatarView()
            }
        }
    }

    private func avatarView() -> some View {
        Image.profile
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color.blue)
      
    }
}


extension Image {
    static var profile: Image {
        Image("test")
    }
    
}
