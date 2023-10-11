//
//  ContentView.swift
//  MyAnime
//
//  Created by Johnny on 29/9/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    init() {
    }

    var body: some View {
        NavigationView {
            ZStack {
                TabView {
                    HomePageView().tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }

                    FavouriteAnimeView().tabItem {
                        Image(systemName: "house.fill")
                        Text("Favourite")
                    }
                }
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
