//
//  JikanAPI.swift
//  MyAnime
//
//  Created by Johnny on 3/10/2023.
//

import Foundation

// MARK: <<APIPath>>
protocol APIPath {
    func top(at page: Int, subtype: AnimeTopSubtype) -> URL
    func anime(id: Int) -> URL
    func search(page: Int, query: String) -> URL
    func genre(id: Int, page: Int) -> URL
    func search(_ types: SearchType...) -> URL
}

enum UserAnimeListFilter: String {
    case all, watching, completed, onhold, dropped, plantowatch
}

enum Genre: Int, CaseIterable {
    case Action = 1
    case Adventure
    case Cars
    case Comedy
    case Dementia, Demons, Mystery, Drama, Ecchi, Fantasy, Game, Hentai, Historical, Horror, Kids, Magic, Mecha, Music, Parody, Samurai, Romance, School, Scifi, Shoujo, ShoujiAi, Shounen, ShounenAi, Space, Sports, SuperPower, Vampire, Yaoi, Yuri, Harem, SliceOfLife, SuperNatural, Military, Police, Psychological, Thriller, Seinen, Josei
}


enum SearchType {
    case query(String)
    case page(Int)
    case type(AnimeTopSubtype)
    case status(AnimeStatus)
    case rated(AnimeRated)
    case genres([Genre])
    case orderBy(AnimeSearchOrderBy)
    case score(Float)
    case genreExclude(Bool)
    case limit(Int)
    case sort(AnimeSearchSort)
    case letter(String)
}

enum AnimeSearchOrderBy: String {
    case title
    case startDate = "start_date"
    case endDate = "end_date"
    case score
    case type
    case members
    case id
    case episodes
    case rating
}

enum AnimeSearchSort: String {
    case asc, desc
}

enum AnimeRated: String {
    case g
    case pg
    case pg13
    case r17
    case r
    case rx
}

enum AnimeStatus: String {
    case airing
    case complete
    case toBeAired = "to_be_aired"
    case tba
    case upcoming
}

// MARK: SearchParameter
enum SearchParameter: String {
    case q
    case page
    case type //AnimeTopSubtypeRequest
    case status
    case rated
    case genre
    case orderBy = "order_by"
    case score
    case genreExclude = "genre_exclude"
    case limit
    case sort
    case letter
}

// MARK: - JikanAPI
class JikanAnimeAPI {
    //  Base on https://jikan.moe API
    
    private let baseURL: String = "https://api.jikan.moe/v4"
    
    private var anime: URL { return
        URL(string: baseURL + "/anime")! }
    
    private var top: URL {
        return URL(string: baseURL + "/top/anime")! }
    
    private var search: URL {
        return URL(string: baseURL + "/anime")! }
    
    private var genre: URL {
        return URL(string: baseURL + "/genre/anime")! }
    
    private var user: URL {
        return URL(string: baseURL + "/user")!
    }
}

extension JikanAnimeAPI: APIPath {
    // URL Functionality for each API path
    
    // MARK: TOP ANIMES PATH
    func top(at page: Int = 1, subtype: AnimeTopSubtype) -> URL {
        var fetchURL = top.appending(queryItems: [URLQueryItem(name: "page", value: "\(page)")])
        
        switch subtype {
        case .bydefault:
            // Do nothing
            print()
        case .bypopularity:
            fetchURL = fetchURL.appendingPathComponent("bypopularity")
        default:
            fetchURL = fetchURL.appendingPathComponent(String(describing: subtype))
        }
    
        return fetchURL
    }
    
    // MARK: SINGLE ANIME
    func anime(id: Int) -> URL {
        let fetchURL = anime.appendingPathComponent(String(id))
        
        return fetchURL
    }
    
    // MARK: SEARCH ANIMES
    func search(page: Int, query: String) -> URL {
        let endQuery: [SearchParameter: String]
        
        guard query.count != 0 else { return search }
        
        if query.count == 1 {
            endQuery = [
                .page: String(page),
                .letter: query,
                .orderBy: "members"
            ]
        }
        else {
            endQuery = [
                .q : query,
                .page: String(page)
                
            ]
        }
        
        let fetchURL = search.searchWithQueries(endQuery)!
        
        return fetchURL
    }
    
    // MARK: SEARCH ANIME BY SEARCH TYPE
    func search(_ types: SearchType...) -> URL {
        var endQuery: [SearchParameter: String] = [:]
        
        for type in types {
            func addQuery(_ value: [SearchParameter: String]) {
                endQuery.merge(value) { current, new in
                    new
                }
            }
            
            switch type {
            case .query(let query):
                if query.count < 3 {
                    addQuery([
                        .letter: query,
                        .orderBy: "members"
                    ])
                }
                else {
                    addQuery([.q : query])
                }
            case .type(let animeType):
                addQuery([.type: animeType.rawValue])
            case .status(let status): addQuery([.status: status.rawValue])
            case .rated(let rated): addQuery([.rated: rated.rawValue])
            case .genres(let genres):
                let genresValue = genres.map({"\($0.rawValue)"}).joined(separator: ",")
                addQuery([.genre: genresValue])
            case .genreExclude(let genreExclude):
                addQuery([.genreExclude: genreExclude ? "0" : "1"])
            case .score(let score):
                addQuery([.score: String(score)])
            case .limit(let limit):
                addQuery([.limit: String(limit)])
            case .orderBy(let orderBy):
                addQuery([.orderBy: orderBy.rawValue])
            case .sort(let sort):
                addQuery([.sort: sort.rawValue])
            case .letter(let letter):
                addQuery([.letter: letter])
            case .page(let page):
                addQuery([.page: String(page)])
            }
        }
        
        let fetchURL = search.searchWithQueries(endQuery)!
        
        return fetchURL
    }
    
    // MARK: GENRE
    func genre(id: Int, page: Int = 1) -> URL {
        return genre
            .appendingPathComponent(String(id))
            .appendingPathComponent(String(page))
    }
    
    // MARK: USER
    func userAnime(_ username: String, list: UserAnimeListFilter ) -> URL {
        var fetchedURL = user.appendingPathComponent(username).appendingPathComponent("animelist").appendingPathComponent(list.rawValue)
        
        
        return fetchedURL
    }
}
