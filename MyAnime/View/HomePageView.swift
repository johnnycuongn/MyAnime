//
//  HomePageView.swift
//  MyAnime
//
//  Created by Johnny on 3/10/2023.
//

import SwiftUI

struct AnimeCardView: View {
    let anime: AnimeDetails
    
    var body: some View {
            ZStack(alignment: .bottom) {
                if let url = URL(string: (anime.images?.jpg.image_url)!) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 150)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
                
                Text(anime.title)
                    .font(.caption)
                    .cornerRadius(10)
                    
                    .padding([.leading, .trailing, .bottom], 8)
                    .padding(.top, 4)
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
        }
}

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
