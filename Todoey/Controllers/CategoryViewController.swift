//
//  CategoryViewController.swift
//  Todoey
//
//  Created by David Erosa on 29/10/18.
//  Copyright © 2018 David Erosa. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoriesArray = [Category]()
    let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadCategories()
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        row.textLabel?.text = categoriesArray[indexPath.row].name!
        return row
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func loadCategories(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoriesArray = try context.fetch(request)
        } catch {
            print("Error loading categories")
        }
        tableView.reloadData()
    }
    
    func saveCategories(){
        do {
            try context.save()
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
                
                let newCategory = Category(context: self.context)
                newCategory.name = newCategoryText
                self.categoriesArray.append(newCategory)
                self.saveCategories()
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
