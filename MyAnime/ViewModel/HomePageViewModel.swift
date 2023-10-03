//
//  HomePageViewModel.swift
//  MyAnime
//
//  Created by Johnny on 3/10/2023.
//

import Foundation

class HomePageViewModel: ObservableObject {
    @Published var topAnimes = [AnimeDetails]()
    @Published var error: String? = .none
    
    let model: DefaultAnimeFetchRepository = DefaultAnimeFetchRepository()
    
    func loadAnimes(page: Int = 2, subtype: AnimeTopSubtype) {
        
        model.fetchTop(page: page, subtype: subtype) { [weak self] (result) in
            switch result {
            
            case .success(let topAnimesData):
                print("HomePage Success fetching top animes")
                print(topAnimesData)
                self?.error = nil
                
                self?.topAnimes.append(contentsOf: topAnimesData)
                
                
            case .failure(let error):
                print("HomePage Error: \(error)")
                self?.handleError(error)
            }
        }
        
    }
    
    fileprivate func handleError(_ error: Error) {
        if let error = error as? HTTPError {
            switch error {
            case .invalidResponse:
                self.error = "Unable to load animes"
            default:
                self.error = "Failed to load"
            }
        }
    }
}
