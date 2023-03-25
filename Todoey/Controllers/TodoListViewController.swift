//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{
    
    let realm = try! Realm()
    
    var items: Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Path to the documentDirectory for our PList and database
        //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        
        
        //print(dataFilePath)
        
        tableView.separatorStyle = .none
        
        
    }
    
    

    //MARK: - Tableview Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage:CGFloat(indexPath.row)/CGFloat(items!.count)){
                
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            
            //Ternary Operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Item Added!"
        }
        
        
        
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row]{
            do{
                try realm.write{
                    //realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Error upating done status, \(error)")
            }
        }
        
        
        tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK: - Add New Item

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving newItem, \(error)")
                }
            }
            
            self.tableView.reloadData()
   
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
    
    //load/Read items from database
    func loadItems(){
        
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do{
                try realm.write(){
                    realm.delete(item)
                }
            }catch{
                print("Error deleting item, \(error)")
            }
        }
    }

}



//MARK: - SearchBar Delegate Method
extension TodoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        items = items?.filter("title CONTAINS %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

