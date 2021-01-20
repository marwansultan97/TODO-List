//
//  Item+CoreDataProperties.swift
//  to do list
//
//  Created by Marwan Osama on 1/19/21.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var color: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var category: Category?

}

extension Item : Identifiable {

}
