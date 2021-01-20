//
//  Extensions.swift
//  to do list
//
//  Created by Marwan Osama on 1/19/21.
//

import UIKit
import CoreData

extension UIViewController {
    
    var context: NSManagedObjectContext {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        return appdelegate.persistentContainer.viewContext
    }
    
}
