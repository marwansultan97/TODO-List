//
//  Category.swift
//  TODO List
//
//  Created by Marwan Osama on 9/8/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryTableView: UITableViewController {
    
    let realm = try! Realm()
    var categoryArray : Results<Category>?
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        retrieveData()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: FlatWhite(), isFlat: true)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Category Added"
        let color = UIColor.init(hexString: (categoryArray?[indexPath.row].color)!)
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListVC
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let errorLabel = UILabel(frame: CGRect(x: 0, y: 40, width: 270, height: 18))
        errorLabel.textAlignment = .center
        errorLabel.font = errorLabel.font.withSize(12)
        errorLabel.textColor = .red
        errorLabel.isHidden = true
        
        
        
        let alert = UIAlertController.init(title: "Add", message: "", preferredStyle: .alert)
        alert.view.addSubview(errorLabel)
        let action = UIAlertAction.init(title: "Create", style: .default) { (action) in
            if textField.text == "" {
                errorLabel.isHidden = false
                errorLabel.text = "Please Add Something"
                self.present(alert, animated: true, completion: nil)
            }else {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.date = Date()
                newCategory.color = UIColor.init(randomFlatColorOf: .light).hexValue()
                self.saveData(category: newCategory)
                
                
            }
            
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Category"
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
    
    func saveData(category : Category) {
        try! realm.write {
                realm.add(category)
        }
        tableView.reloadData()
        
    }
    
    func retrieveData() {
        
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()

    }

}

// MARK: - SearchBar


//extension CategoryTableView : UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
//        categoryArray = realm.objects(Category.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
//        tableView.reloadData()
//        tableView.reloadData()
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text == "" {
//            retrieveData()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//                self.retrieveData()
//
//            }
//        }
//    }
//}


// MARK: - SwipeCell

extension CategoryTableView : SwipeTableViewCellDelegate {
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            let category = self.categoryArray?[indexPath.row]
            do{
                try self.realm.write {
                    self.realm.delete(category!)
                }
            } catch {
                print(error)
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "trash")
        
        return [deleteAction]
    }
    

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}
