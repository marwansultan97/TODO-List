//
//  Category.swift
//  TODO List
//
//  Created by Marwan Osama on 9/8/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryTableView: UITableViewController {
    
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveData()
        


    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        


    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListVC
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            context.delete(categoryArray[indexPath.row])
            categoryArray.remove(at: indexPath.row)
            saveData()
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
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text
                self.categoryArray.append(newCategory)
                self.saveData()
                
                
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
    
    func saveData() {
        do {
            try context.save()
        }catch {
            print("error saving Data \(error)")
        }
        tableView.reloadData()
        
    }
    
    func retrieveData() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
           categoryArray = try context.fetch(request)
            
        }catch {
            print("error fetching \(error)")
        }
    }

}


extension CategoryTableView : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            categoryArray = try context.fetch(request)
            
        }catch {
            print("error fetching \(error)")
        }
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            retrieveData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.retrieveData()
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
}
