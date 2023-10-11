//
//  HomePageView.swift
//  MyAnime
//
//  Created by Johnny on 3/10/2023.
//

import SwiftUI


struct HomePageView: View {
    @ObservedObject var viewModel = HomePageViewModel()
    
    @State var searchText = ""
    @State private var searchTimer: Timer? = nil
    
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
            
            VStack {
                // Search Bar
                TextField("Search for an anime...", text: $searchText, onCommit: {
                    viewModel.searchAnimes(searchText: searchText)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing, .top], 16)
                .onChange(of: searchText) { newValue in
                    searchTimer?.invalidate()
                    searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                        viewModel.searchAnimes(searchText: newValue)
                    }
                }
                
                // Anime Grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        let animesToShow = viewModel.isSearching ? viewModel.searchResults : viewModel.topAnimes
                        ForEach(Array(animesToShow.enumerated()), id: \.1.malID) { index, anime in
                            AnimeCardView(anime: anime)
                            // your existing logic for loading next page
                            if index == viewModel.topAnimes.count - 5 && !viewModel.isSearching { // 5 from the end
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
                .gesture(DragGesture().onChanged { _ in
                    hideKeyboard()
                })
            }
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
