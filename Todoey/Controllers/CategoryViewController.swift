//
//  CategoryViewController.swift
//  Todoey
//
//  Created by mac on 25/02/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray = [Category]()
    
    
    //context to persist data to database(Core data/Sqllite)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    //MARK: - TableView Data Source Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    
    
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
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
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
//        do{
//            categoryArray = try context.fetch(request)
//        }catch{
//            print("Error fetching data from context \(error)")
//        }

        tableView.reloadData()
    }
    
    
    
    //MARK: - TableView delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
}
