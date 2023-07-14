//
//  CategoryViewController.swift
//  Todoey
//
//  Created by MohammedAyman on 5/24/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{
    let realm = try! Realm()
    
    var categoriesArray: Results<Category>?
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategorys()
        
    }
  
    
    
    
    //MARK: - TableView Datasourse Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 1
    }
    /*   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
     cell.delegate = self
     return cell
     }*/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categoriesArray?[indexPath.row]{
            cell.textLabel?.text = category.name
            cell.backgroundColor = UIColor(hexString: (category.hexColor) )
            cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: (category.hexColor))!, returnFlat: true)
            
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! TodoListViewController
        
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVc.selectedCategroy = categoriesArray?[indexPath.row]
        }
    }
    
    
    
    
    
    
    //MARK: - Data Manipulation Methods
    
    
    func save(category:Category){
        
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print(error)
        }
        self.tableView.reloadData()
    }
    func loadCategorys() {
        
        categoriesArray = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    //MARK: - delete data
    override func updateModel(at indexPath: IndexPath) {
        if let deleteCategory = self.categoriesArray?[indexPath.row]{
            do {
                try self.realm.write{
                    self.realm.delete(deleteCategory)
                }
            }catch{
                print(error)
            }
            
        }
    }
    
    //MARK: - Add New Categories
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.hexColor = RandomFlatColor().hexValue()
            
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
            textField.returnKeyType = .go
        }
        present(alert, animated: true, completion: nil)
    }
    
    
}

/*extension CategoryViewController:SwipeTableViewCellDelegate{
 
 func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
 guard orientation == .right else { return nil }
 
 let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
 // handle action by updating model with deletion
 //  print("item deleted")
 if let deleteCategory = self.categoriesArray?[indexPath.row]{
 do {
 try self.realm.write{
 self.realm.delete(deleteCategory)
 }
 }catch{
 print(error)
 }
 
 }
 
 }
 
 // customize the action appearance
 deleteAction.image = UIImage(named: "delete-icon")
 
 return [deleteAction]
 }
 
 
 func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
 
 var options = SwipeOptions()
 options.expansionStyle = .destructive
 
 return options
 }
 }
 */
