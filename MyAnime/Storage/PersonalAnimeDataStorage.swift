//
//  PersonalAnimeDataStorage.swift
//  MyAnime
//
//  Created by Johnny on 29/9/2023.
//

import Foundation
import CoreData

protocol PersonalAnimeStorageCreateDelete {
    func add(id: Int, imageData: Data?, title: String?, date: Date)
    
    func remove(id: Int, completion: @escaping () -> Void)
    
    func isIDExist(_ id: Int, completion: @escaping (Bool) -> Void)
}

protocol PersonalAnimeStorageRead {
}

protocol PersonalAnimeStorage: PersonalAnimeStorageCreateDelete, PersonalAnimeStorageRead  {

    
}

class DefaultPersonalAnimeStorage: PersonalAnimeStorage {
    private var storage: CoreDataStorage = CoreDataStorage.shared
    
    init(storage: CoreDataStorage = CoreDataStorage.shared) {
        self.storage = storage
    }
    
    func add(id: Int, imageData: Data?, title: String?, date: Date) {
        let entity = AnimeEntity(context: storage.context)
        
        entity.id = Int64(id)
        entity.image = imageData
        entity.title = title
        
        storage.saveContext()
        
    }
    
    func remove(id: Int, completion: @escaping () -> Void) {
        let request = requestFor(id: id)
        
        
        do {
            let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: request) {
                (asyncFetchResult) in
                
                guard let idArray = asyncFetchResult.finalResult else { return }
                
                for id in idArray {
                    self.storage.context.delete(id)
                }
                
                self.storage.saveContext()
                completion()
            }
            
            try storage.context.execute(asyncFetchRequest)
            
        }
        catch let error {
            print("Data Manager Error: \(error)")
        }
            
    }
    
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
    private func fetchRequest() -> NSFetchRequest<AnimeEntity> {
        let request = AnimeEntity.fetchRequest() as NSFetchRequest<AnimeEntity>
        
        request.sortDescriptors = [NSSortDescriptor(key: "dateSaved", ascending: true)]
        
        return request
    }
    
    private func requestFor(id: Int) -> NSFetchRequest<AnimeEntity> {
        let request = AnimeEntity.fetchRequest() as NSFetchRequest<AnimeEntity>
        let predicate = NSPredicate(format: "id == %d", id)
        request.predicate = predicate
        
        return request
    }
    
    
}
