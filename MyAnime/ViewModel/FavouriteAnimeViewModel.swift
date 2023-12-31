//
//  FavouriteAnimeViewModel.swift
//  MyAnime
//
//  Created by Johnny on 4/10/2023.
//

import Foundation

class FavouriteAnimeViewModel: ObservableObject {
    @Published var animes: [FavouriteAnime] = []
    @Published var error: String = ""
    
    private let model = DefaultFavoriteAnimeModel()
    
    init() {
    }
    
    func load() {
        model.getAnimes { result in
            switch result {
            case .success(let animes):
                self.animes = animes
            case .failure(let error):
                print("Favourite Anime View Model \(error)")
                self.error = "Error loading favourite animes"
            }
        }
    }
    
    func unfavoriteAnime(id: Int) {
        self.model.remove(id: id) { success in
            if !success {
                self.error = "Error removing anime"
            } else {
                self.load()
            }
        }
    }
    
}
