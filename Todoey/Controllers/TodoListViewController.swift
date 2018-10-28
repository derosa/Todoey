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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath!)
        loadItems()
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
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    func saveItems() {
        //self.defaults.set(self.itemArray, forKey: self.SAVED_ITEMS_KEY)
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding data! ")
        }

        tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding!")
            }
        }
        
        tableView.reloadData()
    }
    
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
                    
                    self.saveItems()
                    
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

