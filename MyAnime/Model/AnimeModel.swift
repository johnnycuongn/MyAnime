//
//  AnimeModel.swift
//  MyAnime
//
//  Created by Johnny on 3/10/2023.
//

import Foundation

enum AnimeFetchError: Error {
    case invalidData
}


//MARK: - Default Implementation
class DefaultAnimeFetchRepository {
    
    private var networkManager: Networking
    private var apiPath: APIPath
    
    init(networkManager: Networking = NetworkManager(), apiPath: APIPath = JikanAnimeAPI()) {
        self.networkManager = networkManager
        self.apiPath = apiPath
    }
    
    // MARK: ANIME DETAILS
    func fetchAnimeDetails(id: Int, completion: @escaping (Result<AnimeDetails, Error>) -> Void) {
        let endpointURL = apiPath.anime(id: id)
        print("Fetch Anime URL - \(endpointURL)")
        
        networkManager.request(url: endpointURL) { (data,error)  in
            guard let data = data else {
                completion(.failure(AnimeFetchError.invalidData))
                return
            }
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            do {
                let anime = try JSONDecoder().decode(AnimeDetails.self, from: data)
            
                DispatchQueue.main.async {
                    completion(.success(anime))
                }
            }
            catch let error {
                print("Anime Fetch Error: \(error)")
                completion(.failure(error))
            }
        }
    }

    // MARK: TOP ANIMES
    var topItemsLoadPerPage: Int = 50
    
    func fetchTop(page: Int, subtype: AnimeTopSubtype, completion: @escaping (Result<[AnimeDetails], Error>) -> Void) {
        
        let endpointURL = apiPath.top(at: page, subtype: subtype)
        print("Top Fetch URL: \(endpointURL)")
        
        networkManager.request(url: endpointURL) { (data,error)  in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data = data else {
                completion(.failure(AnimeFetchError.invalidData))
                return
            }

            do {
                let topAnimeMain = try JSONDecoder().decode(TopAnimesResponse.self, from: data)
                
                print("Top Anime \(topAnimeMain)")
                
                DispatchQueue.main.async {
                    completion(.success(topAnimeMain.data))
                }
            }
            catch let error {
                print("TopAnimeService: Fetch Error - \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: SEARCH ANIMES
    var currentSearchDataTask: URLSessionTask?
    
    func fetchSearch(page: Int, query: String, completion: @escaping (Result<[AnimeDetails], Error>) -> Void) {
        currentSearchDataTask?.cancel()
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            completion(.success([]))
            return
        }
        
        let endpointURL = apiPath.search(page: page, query: query)
        print("Search Fetch URL: \(endpointURL)")
        

        currentSearchDataTask = networkManager.request(url: endpointURL) { (data,error) in
            guard let data = data else {
                completion(.failure(AnimeFetchError.invalidData))
                return
            }
            
            do {
                let searchReponseDTO = try JSONDecoder().decode(SearchAnimeMainResponse.self, from: data)
                
                print("Success search")
                print(searchReponseDTO)
                
                DispatchQueue.main.async {
                    completion(.success(searchReponseDTO.data))
                }
            }
            catch let error {
                print("SearchAnimeService: \(error)")
                completion(.failure(error))
            }
        }
    }
}
