//
//  CategoryViewController.swift
//  Todoey
//
//  Created by David Erosa on 29/10/18.
//  Copyright © 2018 David Erosa. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
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
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            cell.backgroundColor = UIColor(hexString: category.cellColor)
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        }
        
        return cell
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
    
    override func updateModel(at indexPath: IndexPath) {
        // First, delete items under this category
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion.items)
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error borrando categoría: \(error)")
            }
        }
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
                newCategory.cellColor = UIColor(randomFlatColorOf: .light).hexValue()
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
