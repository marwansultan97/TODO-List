//
//  ViewController.swift
//  TODO List
//
//  Created by Marwan Osama on 9/4/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import UIKit

class ToDoListVC: UITableViewController {
    
    var itemArray = [Item]()
    let dataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        retrieveData()
        print(dataURL)
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        
        // ternary operator
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // if true make it false and if false make it true
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        saveData()
        
        
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
                let newItem = Item()
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                self.saveData()
                }

                self.tableView.reloadData()
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
    
    
    func saveData() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataURL!)
        }catch {
            print("error encoding \(error)")
            
            
        }
        self.tableView.reloadData()
        
    }
    
    func retrieveData() {
        do {
            let data = try? Data(contentsOf: dataURL!)
            let decoder = PropertyListDecoder()
            itemArray = try decoder.decode([Item].self, from: data!)
        }catch {
            print("error decoding \(error)")
        }
        
    }
    

}

