//
//  FavouriteAnimeCardView.swift
//  MyAnime
//
//  Created by Johnny on 4/10/2023.
//

import SwiftUI

struct FavouriteAnimeCardView: View {
    let anime: FavouriteAnime
    
    var body: some View {
            ZStack(alignment: .bottom) {
                if let image = anime.imageData, let uiImage = UIImage(data: image) {
                    Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
                
                Text(anime.title ?? "")
                    .font(.caption)
                    .cornerRadius(10)
                
                    .padding([.leading, .trailing, .bottom], 8)
                    .padding(.top, 4)
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
    }
}

struct FavouriteAnimeCardView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteAnimeCardView(anime: .init(id: 1, title: "sd"))
    }
}
