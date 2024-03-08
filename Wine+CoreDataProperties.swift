//
//  Wine+CoreDataProperties.swift
//  dataPersistanceMiniApp
//
//  Created by Jonah Whitney on 3/6/24.
//
//

import Foundation
import CoreData


extension Wine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wine> {
        return NSFetchRequest<Wine>(entityName: "Wine")
    }

    @NSManaged public var name: String?
    @NSManaged public var color: String?
    @NSManaged public var type: String?
    @NSManaged public var quantity: Int64

}

extension Wine : Identifiable {

}
