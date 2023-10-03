//
//  HomePageView.swift
//  MyAnime
//
//  Created by Johnny on 3/10/2023.
//

import SwiftUI


struct HomePageView: View {
    @ObservedObject var viewModel = HomePageViewModel()
    
    init() {
       
    }
    
    var body: some View {

        ScrollView {
               LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                   ForEach(viewModel.topAnimes, id: \.malID) { anime in
                       AnimeCardView(anime: anime)
                   }
               }
               .padding(16)
        }.onAppear {
            viewModel.loadAnimes(subtype: .bydefault)
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
