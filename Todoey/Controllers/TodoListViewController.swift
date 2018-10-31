//
//  ViewController.swift
//  Todoey
//
//  Created by David Erosa on 28/10/18.
//  Copyright © 2018 David Erosa. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    //override var prefersStatusBarHidden: Bool { return true }
    let realm = try! Realm()
    
    var todoItems :Results<Item>?

    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {

        guard let bgColor = selectedCategory?.cellColor else { fatalError("Category has no color!") }
        
        title = selectedCategory?.name
        
        updateNavBar(withHexCode: bgColor)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "85BFFF")
    }
    
    //MARK: - Nav Bar Setup Methods
    func updateNavBar(withHexCode colorHexCode : String){
        guard let navBar = navigationController?.navigationBar else { fatalError("No navigation bar.")}
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError("Can't create color.")}

        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.backgroundColor = navBarColor
//        searchBar.searchBarStyle = .prominent
    }
    
    override func didReceiveMemoryWarning() {
        print("didReceiveMemoryWarning")
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            let percentage = Float(indexPath.row)/Float(todoItems!.count)
            let categoryColor = UIColor(hexString: selectedCategory?.cellColor ??  UIColor.white.hexValue())
            
            cell.backgroundColor = categoryColor?.darken(byPercentage: CGFloat(percentage))
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            
        } else {
            cell.textLabel?.text = "No Items added"
        }
        
        
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print ("Error saving done status: \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Item", message: "Enter your new item", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen one the user press the add item button
            print("Action OK")
            
            if let newItemText = textField.text{
                if newItemText.count > 0 {
                    if let currentCategory = self.selectedCategory {
                        do {
                            try self.realm.write {
                                let newItem = Item()
                                newItem.title = newItemText
                                newItem.dateCreated = Date()
                                currentCategory.items.append(newItem)
                            }
                            print("Saved!")
                        } catch {
                            print ("Error saving item: \(error)")
                        }
                    }
                    
                    self.tableView.reloadData()

                }
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add your item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let itemForDeletion = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                print("Error borrando item: \(error)")
            }
        }
        
    }
    
    
}

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Searching " + searchBar.text!)
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
