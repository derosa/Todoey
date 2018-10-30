//
//  CategoryViewController.swift
//  Todoey
//
//  Created by David Erosa on 29/10/18.
//  Copyright © 2018 David Erosa. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        row.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet"
        return row
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
        
    }
    
    func saveCategories(category : Category){
        do {
            // CoreData
            // try context.save()
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories")
        }
        tableView.reloadData()
    }
    

    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: Any) {
        var alertTextField : UITextField = UITextField()
        
        let alertController = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            print("Adding category - Button presed")
            if let newCategoryText = alertTextField.text {
                if newCategoryText == "" { return }

                let newCategory = Category()
                newCategory.name = newCategoryText
                self.saveCategories(category: newCategory)
                print ("Done!")
            }
        }
        
        alertController.addTextField { (textField) in
            alertTextField = textField
            alertTextField.placeholder = "Add Category"
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
