//
//  AnimeDetailsPage.swift
//  MyAnime
//
//  Created by Johnny on 3/10/2023.
//

import SwiftUI

struct AnimeDetailsPage: View {
    let anime: AnimeDetails
    @State private var isFavorite: Bool = false
    
    init(anime: AnimeDetails) {
        self.anime = anime
    }

    var body: some View {
        ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Anime Image
                        if let urlString = anime.images?.jpg.image_url,
                           let url = URL(string: urlString) {
                            AsyncImage(url: url)
                                .frame(maxWidth: .infinity)
                                .scaledToFit()
                        } else {
                            // Fallback if no image_url or if it's invalid
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit()
                        }
                        
                        // Anime Title
                        Text(anime.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        // Anime Description
                        Text(anime.synopsis ?? "No synopsis available.")
                            .font(.body)
                    }
                    .frame(width: .infinity)
                    .padding(.init(top: 0, leading: 10, bottom: 100, trailing: 10)) // Add padding to avoid overlap with the button
                }
                .frame(maxWidth: .infinity)
            
                // Favorite Button
                VStack {
                    Spacer()
                    Button(action: {
                        isFavorite.toggle()
                    }) {
                        HStack {
                            Text(isFavorite ? "Favorited" : "Add to Favorites")
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    .padding()
                }
            }
            .frame(maxWidth: .infinity)
        }
}
struct AnimeDetailsPage_Previews: PreviewProvider {
    static var previews: some View {
        do {
            let data = try AnimeDetails.mock()
            print("Mock data \(String(describing: data))")
            
            guard data != nil else {
                return AnyView(VStack {
                   Text("No Data")
                   // Other common elements
               })
            }
            
            return AnimeDetailsPage(anime: data!)
        }
        catch let error {
            print(error)
        }
        
        return AnyView(VStack {
           Text("Error")
           // Other common elements
       })
    }////
}
