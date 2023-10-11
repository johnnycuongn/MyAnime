//
//  Model.swift
//  MyAnime
//
//  Created by Johnny on 1/10/2023.
//

import Foundation

enum AnimeType: String, Codable {
    case tv = "TV"
    case movie = "Movie"
    case ova = "OVA"
    case special = "Special"
    case ona = "ONA"
    case music = "Music"
}

class ShortDisplayDTO: Decodable {
    var malID: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.malID = try container.decode(Int.self, forKey: .malID)
        self.name = try container.decode(String.self, forKey: .name)
    }
}

class GenreDisplay: ShortDisplayDTO {}

struct Images: Decodable {
    let jpg: ImageType
    let webp: ImageType
}

struct ImageType: Decodable {
    let image_url: String
    let small_image_url: String
    let large_image_url: String
}



class AnimeDetails: Decodable {
    
    var malID: Int
    var url: String?
    var images: Images?
    var title: String
    var titleEnglish: String?
    var synopsis: String?
    var type: AnimeType?
    var episodes: Int?
    var score: Double?
    var scoredBy: Int?
    var members: Int?
    var rank: Int?
    var popularity: Int?
    var favorites: Int?
    var rating: String?
    var status: String?
    
    var genres: [GenreDisplay]
//    var studios: [StudioDisplayDTO]
    
    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case url
        case images
        case title
        case titleEnglish = "title_english"
        case synopsis
        case type
        case episodes
        case score
        case scoredBy = "scored_by"
        case members
        case rank
        case popularity
        case favorites
        case rating
        case status
        
        case genres
        case studios
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        malID = try container.decode(Int.self, forKey: .malID)
        url = try? container.decode(String.self, forKey: .url)
        images = try? container.decode(Images.self, forKey: .images)
        title = try container.decode(String.self, forKey: .title)
        titleEnglish = try? container.decode(String.self, forKey: .titleEnglish)
        synopsis = try? container.decode(String.self, forKey: .synopsis)
        type = try? container.decode(AnimeType.self, forKey: .type)
        episodes = try? container.decode(Int.self, forKey: .episodes)
        score = try? container.decode(Double.self, forKey: .score)
        scoredBy = try? container.decode(Int.self, forKey: .scoredBy)
        members = try? container.decode(Int.self, forKey: .members)
        rank = try? container.decode(Int.self, forKey: .rank)
        popularity = try? container.decode(Int.self, forKey: .popularity)
        favorites = try? container.decode(Int.self, forKey: .favorites)
        rating = try? container.decode(String.self, forKey: .rating)
        status = try? container.decode(String.self, forKey: .status)
        
        genres = try container.decode([GenreDisplay].self, forKey: .genres)
//        studios = try container.decode([StudioDisplay].self, forKey: .studios)
    }
    
    
    // Return mock data for SwiftUI Previews
    static func mock() throws -> AnimeDetails? {
        let jsonString = """
        {
            "mal_id": 1,
            "url": "https://example.com",
            "images": {
                "jpg": {
                  "image_url": "https://cdn.myanimelist.net/images/anime/10/18793.jpg",
                  "small_image_url": "https://cdn.myanimelist.net/images/anime/10/18793t.jpg",
                  "large_image_url": "https://cdn.myanimelist.net/images/anime/10/18793l.jpg"
                },
                "webp": {
                  "image_url": "https://cdn.myanimelist.net/images/anime/10/18793.webp",
                  "small_image_url": "https://cdn.myanimelist.net/images/anime/10/18793t.webp",
                  "large_image_url": "https://cdn.myanimelist.net/images/anime/10/18793l.webp"
                }
            },
            "title": "Example Anime",
            "title_english": "Example Anime in English",
            "synopsis": "This is a sample synopsis.",
            "type": "TV",
            "episodes": 12,
            "score": 8.5,
            "scored_by": 50000,
            "members": 100000,
            "rank": 1,
            "popularity": 1,
            "favorites": 10000,
            "rating": "PG-13",
            "status": "Airing",
            "genres": [
                {
                    "mal_id": 8,
                  "type": "anime",
                  "name": "Drama",
                  "url": "https://myanimelist.net/anime/genre/8/Drama"
                }
            ]
        }
        """
        print("Mock")
        let jsonData = Data(jsonString.utf8)
        print(String(data: jsonData, encoding: .utf8))
        let decoder = JSONDecoder()
        do {
            let animeDetails = try decoder.decode(AnimeDetails.self, from: jsonData)
            print("Anime")
            print(animeDetails ?? "No DATA")
            return animeDetails

        } catch let error {
            print(error)
        }
        
        
        return nil
        
        
    }
}


// TOP

enum AnimeTopSubtype: String {
    case bydefault = "Rating"
    case bypopularity = "Popularity"
    case favorite = "Favorite"
    case airing = "Airing"
    case upcoming = "Upcoming"
    case tv = "TV"
    case movie = "Movie"
    case ova = "OVA"
    case special = "Special"
}

class TopAnimesResponse: Decodable {
    var data: [AnimeDetails]
    
    enum CodingKeys: String, CodingKey { case data }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        data = try container.decode([AnimeDetails].self, forKey: .data)
    }
}

class TopAnimeResponse: AnimeThumbnailResponse {

}

class AnimeThumbnailResponse: Decodable {
    var malID: Int
    var imageURL: URL?
    var title: String
    var type: AnimeType?
    var episodes: Int?
    var members: Int?
    var score: Double?
    
    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case title
        case imageURL = "image_url"
        case type
        case episodes
        case members
        case score
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        malID = try container.decode(Int.self, forKey: .malID)
        title = try container.decode(String.self, forKey: .title)
        imageURL = try? container.decode(URL.self, forKey: .imageURL)
        type = try? container.decode(AnimeType.self, forKey: .type)
        episodes = try? container.decode(Int.self, forKey: .episodes)
        members = try? container.decode(Int.self, forKey: .members)
        score = try? container.decode(Double.self, forKey: .score)
    }
}


