//
//  ViewController.swift
//  to do list
//
//  Created by Marwan Osama on 1/18/21.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    private let cellIdentifier = "CategoryTableViewCell"
    
    var categoryArray = [Category]() {
        didSet {
            if categoryArray.isEmpty {
                contentView.alpha = 0
            } else {
                contentView.alpha = 1
                categoryTableView.reloadData()
            }
        }
    }
    
    let myColors = [FlatTeal(), FlatSkyBlue(), FlatMintDark(), FlatForestGreen(), FlatGreen(), FlatMaroon(), FlatPowderBlue(), FlatBlue(), FlatCoffee(), FlatPlum(), FlatSand(), FlatNavyBlue(), FlatWhite(), FlatWhiteDark()]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        fetchCategory()
    }
    
    //MARK: - User Interface
    static func storyboardInstance() -> CategoryViewController? {
        let storyoard = UIStoryboard(name: "Category", bundle: nil)
        return storyoard.instantiateInitialViewController() as? CategoryViewController
    }
    
    func configureNavigationBar() {
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addCategory))
        navigationItem.rightBarButtonItem = rightButton
        navigationController?.navigationBar.tintColor = .label
        
    }
    
    func configureTableView() {
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.rowHeight = 60
        categoryTableView.tableFooterView = UIView()
        categoryTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    
    @objc func addCategory() {
        let alert = UIAlertController(title: "Add Category", message: "Please add category", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "..."
        }
        
        let actionSave = UIAlertAction(title: "Save", style: .default) { _ in
            print("Handle Save")
            guard let categoryName = alert.textFields?[0].text else { return }
            self.saveNewCategory(name: categoryName)
        }
        let actionCancle = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        // To disable the save action if textfield is empty
        actionSave.isEnabled = false
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: alert.textFields?[0], queue: OperationQueue.main) { (notification) in
            guard let textfield = alert.textFields?.first else { return }
            actionSave.isEnabled = textfield.text!.isEmpty ? false : true
        }
        
        alert.addAction(actionSave)
        alert.addAction(actionCancle)
        present(alert, animated: true)
    }
    
    //MARK: - Core Data Methods
    func saveNewCategory(name: String) {
        let category = Category(context: self.context)
        category.name = name
        category.color = UIColor(randomColorIn: myColors)?.hexValue()
        category.createdAt = Date()
        do {
            try self.context.save()
        } catch let err {
            print(err.localizedDescription)
        }
        self.fetchCategory()
    }
    
    func fetchCategory() {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let sortByDate = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortByDate]
        do {
            self.categoryArray = try self.context.fetch(fetchRequest)
        } catch let err {
            print(err.localizedDescription)
        }
        
    }
    
    func deleteCategory(category: Category) {
        self.context.delete(category)
        do {
            try self.context.save()
        } catch let err {
            print(err.localizedDescription)
        }
        self.fetchCategory()
    }
    
    
    //MARK: - Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CategoryTableViewCell
        let category = self.categoryArray[indexPath.row]
        cell.configureCell(category: category)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryTableView.deselectRow(at: indexPath, animated: true)
        let categoryToSelect = categoryArray[indexPath.row]
        let itemVC = ItemViewController.storyboardInstance()
        itemVC?.category = categoryToSelect
        navigationController?.pushViewController(itemVC!, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "") { (action, view, handler) in
            let categoryToRemove = self.categoryArray[indexPath.row]
            self.deleteCategory(category: categoryToRemove)
        }
        action.backgroundColor = categoryTableView.cellForRow(at: indexPath)?.backgroundColor?.darken(byPercentage: 0.2)
        action.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    
    


}

