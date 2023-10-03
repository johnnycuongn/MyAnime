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
    
}
