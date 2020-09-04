//
//  ViewController.swift
//  TODO List
//
//  Created by Marwan Osama on 9/4/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import UIKit

class ToDoListVC: UITableViewController {
    
    let itemArray = ["Buy Eggs","Go To the Gym"]
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    
    
    
    
    
    
    
    

}

