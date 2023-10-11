//
//  ServicesExtensions.swift
//  MyAnime
//
//  Created by Johnny on 3/10/2023.
//

import Foundation

extension URL {
    
    // Add queries to url path
    func searchWithQueries(_ queries: [SearchParameter: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map { URLQueryItem(name: $0.key.rawValue , value: $0.value ) }
        return components?.url
    }
}
