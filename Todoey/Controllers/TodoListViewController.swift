//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    //context to persist data to database(Core data/Sqllite)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Path to the documentDirectory for our PList and database
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        
        //print(dataFilePath)
        
        loadItems()
        
    }
    
    

    //MARK: - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        //Ternary Operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //if item.done of the row is true/false then make it the opposite of its current value : refactor for the if-else statement
        //Update data
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        //Delete item when pressed
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK: - Add New Item

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        //Add UITextField to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            
            textField = alertTextField
            
        }
        
        //link the alertAction to the alert
        alert.addAction(action)
        
        //present the alert
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manupulation Method
    
    //save/Create item to database
    func saveItems() {
        
        do{
            try context.save()
        }catch{
            print("Error Saving Context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //load/Read items from database
    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        
    }
}

