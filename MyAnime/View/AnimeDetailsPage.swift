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
    @ObservedObject var viewModel = AnimeDetailsViewModel()
    
    init(anime: AnimeDetails) {
        self.anime = anime
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear // or whatever color you want
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        
        UINavigationBar.appearance().tintColor = .black
    }

    var body: some View {
        ZStack {
            // Background color
            Color.app.main.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Anime Image
                    if let urlString = anime.images?.jpg.image_url,
                       let url = URL(string: urlString) {
                        AsyncImage(url: url)
                            .frame(maxWidth: .infinity)
//                            .scaledToFit()
                    } else {
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    }
                    
                    // Anime Title
                    Text(anime.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.vertical)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("\(anime.score ?? 0.0, specifier: "%.1f")")
                                .font(.caption)
                            Text("-")
                            Text("\(anime.scoredBy ?? 0)")
                                .font(.caption)
                        }
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.blue)
                            Text("\(anime.members ?? 0)")
                                .font(.caption)
                        }
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.red)
                            Text("\(anime.popularity ?? 0)")
                                .font(.caption)
                        }
                        HStack {
                            Image(systemName: "film.fill") // or another equivalent icon of your choice
                                .foregroundColor(.purple)
                            Text("\(anime.episodes ?? 0)")
                                .font(.caption)
                        }
                    }
                    
                    // Anime Description
                    Text(anime.synopsis ?? "No synopsis available.")
                        .font(.body)
                        .padding(.bottom)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 5)
                .padding(.bottom, 100) // Extra padding for the floating button
            }
            .padding(.horizontal)
            
            // Favorite Button
            VStack {
                Spacer()
                Button(action: {
                    viewModel.favoriteAnime(id: self.anime.malID, title: self.anime.title, imageURL: self.anime.images?.jpg.image_url ?? "")
                }) {
                    HStack {
                        Text(viewModel.isAnimeFavorited ? "Favorited" : "Add to Favorites")
                        Image(systemName: viewModel.isAnimeFavorited ? "heart.fill" : "heart")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .shadow(radius: 10)
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            viewModel.load(anime: anime)
        }
    }
}
