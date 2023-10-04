//
//  FavouriteAnimeView.swift
//  MyAnime
//
//  Created by Johnny on 4/10/2023.
//

import SwiftUI

struct FavouriteAnimeCardView: View {
    let anime: FavouriteAnime
    
    let viewModel: FavouriteAnimeViewModel
    
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
                
                VStack {
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.unfavoriteAnime(id: anime.id)
                        }) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 30))
                        }

                        
                    }
                    

                    Text(anime.title ?? "")
                        .font(.caption)
                        .cornerRadius(10)
                        .padding([.leading, .bottom], 8)
                        .padding(.top, 4)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .cornerRadius(10)
                }
                
            }
    }
}

struct FavouriteAnimeView: View {
    
    @ObservedObject var viewModel = FavouriteAnimeViewModel()
    
    init() {
        print("Favoriate anime loading")
    }
    
    var body: some View {
        ScrollView {
               LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                   ForEach(viewModel.animes, id: \.id) { anime in
                       FavouriteAnimeCardView(anime: anime, viewModel: self.viewModel)
                   }
               }
               .padding(16)
        }.onAppear {
            viewModel.load()
        }
    }
}

struct FavouriteAnimeView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteAnimeView()
    }
}
