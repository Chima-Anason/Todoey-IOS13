//
//  CategoryViewController.swift
//  Todoey
//
//  Created by mac on 25/02/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        tableView.rowHeight = 80.0
    }
    
    //MARK: - TableView Data Source Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Added!"
        
        
        return cell
    }
    
    
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        //Add UITextField to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            
            textField = alertTextField
            
        }
        
        //link the alertAction to the alert
        alert.addAction(action)
        
        //present the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Model Manupulation Method
    
    //save/Create item to database
    func save(category: Category) {
        
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error Saving Context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //load/Read items from database
    func loadCategories(){
        
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    //MARK: - Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting the category \(error)")
            }

        }
    }
    
    
    
    //MARK: - TableView delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}


