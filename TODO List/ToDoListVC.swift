//
//  ViewController.swift
//  TODO List
//
//  Created by Marwan Osama on 9/4/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import UIKit

class ToDoListVC: UITableViewController {
    
    var itemArray = ["Buy Eggs","Go To the Gym"]
    let defaults = UserDefaults.standard
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "ToDoList") as? [String] {
            itemArray = items
        }
        
        
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
    

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let errorLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 270, height:18))
        errorLabel.textAlignment = .center
        errorLabel.textColor = .red
        errorLabel.font = errorLabel.font.withSize(12)
        errorLabel.isHidden = true
        
        
        let alert = UIAlertController.init(title: "Add New Do Item", message: "", preferredStyle: .alert)
        alert.view.addSubview(errorLabel)
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            if textField.text == "" {
                errorLabel.isHidden = false
                errorLabel.text = "Please Add Item"
                 self.present(alert, animated: true, completion: nil)
            }else {
                self.itemArray.append(textField.text!)
                self.defaults.setValue(self.itemArray, forKey: "ToDoList")
                self.tableView.reloadData()
            }
            
        }
        
        
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true) {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
        }
        
        
        
        
    }
    
    @objc func dismissAlert() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    

}

