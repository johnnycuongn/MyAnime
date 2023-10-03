//
//  FavouriteAnimeView.swift
//  MyAnime
//
//  Created by Johnny on 4/10/2023.
//

import SwiftUI

struct FavouriteAnimeView: View {
    
    @ObservedObject var viewModel = FavouriteAnimeViewModel()
    
    init() {
        print("Favoriate anime loading")
    }
    
    var body: some View {
        ScrollView {
               LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                   ForEach(viewModel.animes, id: \.id) { anime in
                       FavouriteAnimeCardView(anime: anime)
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
