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
        viewModel.loadAnimes(subtype: .bydefault)
    }
    
    var body: some View {
        ZStack {
            if viewModel.loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2, anchor: .center)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(viewModel.topAnimes, id: \.malID) { anime in
                            AnimeCardView(anime: anime)
                        }
                    }
                    .padding(16)
                }
            }
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
