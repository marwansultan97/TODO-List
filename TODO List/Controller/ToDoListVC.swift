//
//  ViewController.swift
//  TODO List
//
//  Created by Marwan Osama on 9/4/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class ToDoListVC: UITableViewController {
    
    let realm = try! Realm()
    var itemArray : Results<Item>?
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : Category? {
        didSet {
            retrieveData()
            
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        
        retrieveData()
	    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color {
            navigationController?.navigationBar.barTintColor = UIColor(hexString: colorHex)
            searchBar.barTintColor = navigationController?.navigationBar.barTintColor
            navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor(hexString: colorHex)!, returnFlat: true)
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(UIColor(hexString: colorHex)!, returnFlat: true)]
        }
        title = selectedCategory?.name
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "1E518E")
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : FlatWhite()]
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: FlatWhite(), isFlat: true)
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
            let color = UIColor.init(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemArray!.count))
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)


            
            print(CGFloat(indexPath.row) / CGFloat(itemArray!.count))
            
        } else {
            cell.textLabel!.text = "No Items Added"
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
                        self.tableView.reloadData()

                    }
                }
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

    
    
    
    func retrieveData() {
        
        itemArray = selectedCategory?.items.sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()

    }
    

}

// MARK: - SearchBar

extension ToDoListVC : UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        itemArray = selectedCategory?.items.filter(predicate).sorted(byKeyPath: "title", ascending: true)
        

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

// MARK: - SwipeCell

extension ToDoListVC: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            let item = self.itemArray?[indexPath.row]
            try! self.realm.write {
                self.realm.delete(item!)
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

