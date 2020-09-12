//
//  ViewController.swift
//  TODO List
//
//  Created by Marwan Osama on 9/4/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class ToDoListVC: UITableViewController {
    
    let realm = try! Realm()
    var itemArray : Results<Item>?
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : Category? {
        didSet {
            retrieveData()
        }
    }
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveData()
	
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            try! realm.write {
                item.done = !item.done
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            let item = itemArray?[indexPath.row]
            try! realm.write {
                realm.delete(item!)
            }
            tableView.reloadData()
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
                if let currentCategory = self.selectedCategory {
                    try! self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.date = Date()
                        currentCategory.items.append(newItem)
                        
                    }
                }
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

    
    
    
    func retrieveData() {
        
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

    }
    

}


extension ToDoListVC : UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        itemArray = selectedCategory?.items.filter(predicate).sorted(byKeyPath: "date", ascending: true)
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        do {
//            itemArray = try context.fetch(request)
//        }catch {
//            print(error)
//        }
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

