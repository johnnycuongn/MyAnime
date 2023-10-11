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
            Color.app.main.edgesIgnoringSafeArea(.all)
            
            if viewModel.loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2, anchor: .center)
            }
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(Array(viewModel.topAnimes.enumerated()), id: \.1.malID) { index, anime in
                        AnimeCardView(anime: anime)
                        if index == viewModel.topAnimes.count - 5 { // 5 from the end
                            Spacer(minLength: 0)
                                .onAppear(perform: {
                                    print("loading more pagaes")
                                    viewModel.loadNextPage()
                                })
                        }
                    }
                }
                .padding(16)
            }
            

        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
