//
//  ViewController.swift
//  Todoey
//
//  Created by David Erosa on 28/10/18.
//  Copyright © 2018 David Erosa. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    let SAVED_ITEMS_KEY = "TodoArrayList"
    
    //override var prefersStatusBarHidden: Bool { return true }
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedItems = defaults.array(forKey: SAVED_ITEMS_KEY) as? [Item] {
            itemArray = savedItems
        }

        let newItem = Item();
        newItem.title = "Find Mike"
        itemArray.append(newItem)

        let newItem2 = Item();
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)

        let newItem3 = Item();
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)

    }
    
    override func didReceiveMemoryWarning() {
        print("didReceiveMemoryWarning")
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Item", message: "Enter your new item", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen one the user press the add item button
            print("Action OK")
            
            if let newItemText = textField.text{
                if newItemText.count > 0 {
                    let item = Item()
                    item.title = newItemText
                    self.itemArray.append(item)
                    self.defaults.set(self.itemArray, forKey: self.SAVED_ITEMS_KEY)
                    self.tableView.reloadData()
                    print("Saved!")
                }
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add your item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
}

