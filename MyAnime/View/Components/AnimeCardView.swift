//
//  AnimeCardView.swift
//  MyAnime
//
//  Created by Johnny on 3/10/2023.
//

import SwiftUI

struct AnimeCardView: View {
    let anime: AnimeDetails
    
    var body: some View {
        NavigationLink(destination: AnimeDetailsPage(anime: anime)) {
            ZStack(alignment: .bottom) {
                if let url = URL(string: (anime.images?.jpg.image_url)!) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView().frame(width: .infinity)
                    }
                    .frame(height: 200)
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
                
                // Rank at the top right
                if let rank = anime.rank {
                    VStack {
                        HStack {
                            Spacer()
                            Text("\(rank)")
                                .font(.caption)
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                                .padding([.top, .trailing], 2)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct AnimeCardView_Previews: PreviewProvider {
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
            
            return AnimeCardView(anime: data!)
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
