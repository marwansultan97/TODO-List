//
//  ViewController.swift
//  TODO List
//
//  Created by Marwan Osama on 9/4/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import UIKit
import CoreData

class ToDoListVC: UITableViewController {
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : Category? {
        didSet {
            retrieveData()
        }
    }
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
	
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
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            saveData()
        }
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
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
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
        do {
            try context.save()
        }catch {
            print("error saving context \(error)")
            
            
        }
        self.tableView.reloadData()
        
    }
    
    func retrieveData() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        do {
            itemArray = try context.fetch(request)
            
        }catch {
            print(error)
        }
        tableView.reloadData()
        
    }
    

}


extension ToDoListVC : UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        do {
            itemArray = try context.fetch(request)
        }catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text! == "" {
            retrieveData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
 
        }
    }
    
}

