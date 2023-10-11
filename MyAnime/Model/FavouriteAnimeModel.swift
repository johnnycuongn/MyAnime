//
//  PersonalAnimeDataStorage.swift
//  MyAnime
//
//  Created by Johnny on 29/9/2023.
//

import Foundation
import CoreData

protocol PersonalAnimeStorageCreateDelete {
    func add(id: Int, imageURL: String, title: String, date: Date?, completion: @escaping (Bool) -> Void)
    
    func remove(id: Int, completion: @escaping (Bool) -> Void)
    
    func isIDExist(_ id: Int, completion: @escaping (Bool) -> Void)
}

protocol PersonalAnimeStorageRead {
}

protocol FavouriteAnimeModel: PersonalAnimeStorageCreateDelete, PersonalAnimeStorageRead  {

    
}

struct FavouriteAnime {
    
    var id: Int
    var title: String?
    
    var imageData: Data?
    var dateUpdated: Date?
    
    
    func toEntity(in context: NSManagedObjectContext) -> AnimeEntity {
        let entity: AnimeEntity = .init(context: context)
        entity.id = Int64(id)
        entity.title = title
        
        entity.image = imageData
        entity.dateUpdated = dateUpdated
        
        return entity
    }
}

class DefaultFavoriteAnimeModel: FavouriteAnimeModel {
    
    private var storage: CoreDataStorage = CoreDataStorage.shared
    
    init(storage: CoreDataStorage = CoreDataStorage.shared) {
        self.storage = storage
    }
    
    // Get favourite animes from corea data
    func getAnimes(_ completion: @escaping (Result<[FavouriteAnime], Error>) -> Void) {
        storage.performBackgroundTask { (context) in
            do {
                let fetchRequest = self.fetchRequest()
                let animeEntities = try context.fetch(fetchRequest)
                
                completion(
                    .success(animeEntities.map {
                        $0.toModel()
                    })
                )
                
            }
            catch let error {
                print("Error get animes \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // Add anime to favorite anime database
    func add(id: Int, imageURL: String, title: String, date: Date?, completion: @escaping (Bool) -> Void) {
        let entity = AnimeEntity(context: storage.context)
        
        if let url = URL(string: imageURL) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data else {
                    completion(false)
                    return
                }
                print("Image data \(data)")
                
                entity.id = Int64(id)
                entity.title = title
                entity.image = data
                entity.isFavourited = true
                entity.dateUpdated = date ?? Date()
                
                self?.storage.saveContext()
                
                completion(true)
                
            }.resume()
        }
        
    }
    
    // Remove anime from favourite database
    func remove(id: Int, completion: @escaping (Bool) -> Void) {
        let request = requestFor(id: id)
        
        
        do {
            let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: request) {
                (asyncFetchResult) in
                
                guard let idArray = asyncFetchResult.finalResult else {
                    completion(false)
                    return
                }
                
                for id in idArray {
                    self.storage.context.delete(id)
                }
                
                self.storage.saveContext()
                completion(true)
            }
            
            try storage.context.execute(asyncFetchRequest)
            
        }
        catch let error {
            print("Data Manager Error: \(error)")
            completion(false)
        }
            
    }
    
    // Check if the anime is saved in the database
    func isIDExist(_ id: Int, completion: @escaping (Bool) -> Void) {
        let request = requestFor(id: id)
        
        do {
            let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: request) {
                (asyncFetchResult) in
                
                guard let idArray = asyncFetchResult.finalResult else { return }
                
                
                if idArray.isEmpty {
                    completion(false)
                }
                else { completion(true) }
                
            }
            
            try storage.context.execute(asyncFetchRequest)
            
        }
        catch let error {
            print("Data Manager Error: \(error)")
        }
    }
    
    // MARK: HELPERS
    
    // Core data GET request for Anime Entity
    private func fetchRequest() -> NSFetchRequest<AnimeEntity> {
        let request = AnimeEntity.fetchRequest() as NSFetchRequest<AnimeEntity>
        
        request.sortDescriptors = [NSSortDescriptor(key: "dateUpdated", ascending: true)]
        
        // Fetch only the favorite anime
        let predicate = NSPredicate(format: "isFavourited == %@", NSNumber(value: true))
        request.predicate = predicate
        
        return request
    }
    
    private func requestFor(id: Int) -> NSFetchRequest<AnimeEntity> {
        let request = AnimeEntity.fetchRequest() as NSFetchRequest<AnimeEntity>
        let predicate = NSPredicate(format: "id == %d", id)
        request.predicate = predicate
        
        return request
    }
    
    
}
