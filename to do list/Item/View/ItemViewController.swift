//
//  ItemViewController.swift
//  to do list
//
//  Created by Marwan Osama on 1/19/21.
//

import UIKit
import CoreData

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    private let cellIdentifier = "ItemTableViewCell"
    
    var category: Category?
    
    var itemArray = [Item]() {
        didSet {
            if itemArray.isEmpty {
                contentView.alpha = 0
            } else {
                contentView.alpha = 1
                self.itemTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        fetchItems()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
    }
 
    
    //MARK: - UI Methods
    static func storyboardInstance() -> ItemViewController? {
        let storyboard = UIStoryboard(name: "Item", bundle: nil)
        return storyboard.instantiateInitialViewController() as? ItemViewController
    }
    
    func configureNavBar() {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addItem))
        navigationItem.rightBarButtonItem = button
        navigationController?.navigationBar.barTintColor = UIColor(hexString: category!.color!)
        navigationController?.navigationBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: category!.color!)!, isFlat: true)
        title = category?.name
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navigationController?.navigationBar.tintColor as Any]
        
    }
    
    func configureTableView() {
        itemTableView.delegate = self
        itemTableView.dataSource = self
        itemTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        itemTableView.rowHeight = 60
        itemTableView.tableFooterView = UIView()
    }
    
    @objc func addItem() {
        let alert = UIAlertController(title: "Add", message: "Please add an item", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            print("handle save")
            guard let itemName = alert.textFields?[0].text else { return }
            self.addNewItem(name: itemName)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        saveAction.isEnabled = false
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Add item"
        }
        // To disable the save action if textfield is empty
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: alert.textFields?[0], queue: OperationQueue.main) { _ in
            guard let text = alert.textFields?[0].text else { return }
            saveAction.isEnabled = text.isEmpty ? false : true
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
    
    //MARK: - Core Data Methods
    func fetchItems() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let predicateCategory = NSPredicate(format: "category == %@", category!)
        fetchRequest.predicate = predicateCategory
        
        let sortDate = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDate]
        do {
            self.itemArray = try self.context.fetch(fetchRequest)
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func addNewItem(name: String) {
        let item = Item(context: self.context)
        item.isDone = false
        item.name = name
        item.createdAt = Date()
        item.category = self.category
        
        do {
            try self.context.save()
        } catch let err {
            print(err.localizedDescription)
        }
        fetchItems()
    }
    
    func deleteItem(item: Item) {
        self.context.delete(item)
        do {
            try self.context.save()
        } catch let err {
            print(err.localizedDescription)
        }
        
        fetchItems()
    }
    
    func changeIsDoneItem(item: Item) {
        item.isDone.toggle()
        do {
            try context.save()
        } catch let err {
            print(err.localizedDescription)
        }
        fetchItems()
    }
    
    //MARK: - Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ItemTableViewCell
        let item = self.itemArray[indexPath.row]
        cell.backgroundColor = UIColor(hexString: category!.color!)?.darken(byPercentage: CGFloat(Double(indexPath.row)*0.05))
        cell.configureCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemTableView.deselectRow(at: indexPath, animated: true)
        let item = itemArray[indexPath.row]
        changeIsDoneItem(item: item)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, handler) in
            let itemToDelete = self.itemArray[indexPath.row]
            self.deleteItem(item: itemToDelete)
        }
        action.backgroundColor = tableView.cellForRow(at: indexPath)?.backgroundColor?.darken(byPercentage: 0.15)
        action.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [action])
    }
    

}
