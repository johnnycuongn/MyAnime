//
//  AnimeEntity+CoreDataProperties.swift
//  MyAnime
//
//  Created by Johnny on 3/10/2023.
//
//

import Foundation
import CoreData


extension AnimeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AnimeEntity> {
        return NSFetchRequest<AnimeEntity>(entityName: "AnimeEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var isFavourited: Bool
    @NSManaged public var dateUpdated: Date?
    @NSManaged public var image: Data?

}

extension AnimeEntity : Identifiable {

}

extension AnimeEntity {
    func toModel() -> FavouriteAnime {
        return .init(id: Int(id), title: title, imageData: image, dateUpdated: dateUpdated)
    }
}
