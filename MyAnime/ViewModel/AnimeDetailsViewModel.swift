//
//  AnimeDetailsViewModel.swift
//  MyAnime
//
//  Created by Johnny on 4/10/2023.
//

import Foundation

class AnimeDetailsViewModel: ObservableObject {
    private let favouriteModel = DefaultFavoriteAnimeModel()
    
    @Published var isAnimeFavorited = false
    @Published var error = ""
    
    private var anime: AnimeDetails?
    
    public func load(anime: AnimeDetails) {
        self.anime = anime
        self.favouriteModel.isIDExist(anime.malID) { isExisted in
            self.isAnimeFavorited = isExisted
        }
    }
    
    public func favoriteAnime(id: Int, title: String, imageURL: String) {
        if isAnimeFavorited {
            print("Unfavorite anime \(id)")
            self.unfavoriteAnime(id: id)
            return
        }
        
        print("Favourite anime \(id)")
        self.favouriteModel.add(id: id, imageURL: imageURL, title: title, date: Date()) { success in
            if success {
                self.error = ""
                self.isAnimeFavorited = true
            } else {
                self.error = "Failed to favorite anime \(title)"
            }
        }
        
    }
    
    private func unfavoriteAnime(id: Int) {
        self.favouriteModel.remove(id: id) { success in
            if success {
                self.error = ""
                self.isAnimeFavorited = false
            } else {
                self.error = "Failed to unfavourite anime"
            }
        }
    }
}
