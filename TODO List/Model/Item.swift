//
//  Item.swift
//  TODO List
//
//  Created by Marwan Osama on 9/10/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {

    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var date : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")


    
    

}
