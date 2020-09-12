//
//  Category.swift
//  TODO List
//
//  Created by Marwan Osama on 9/10/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var date : Date?
    let items = List<Item>()
    
}
