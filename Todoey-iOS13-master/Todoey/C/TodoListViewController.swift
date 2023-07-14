//
//  TodoListViewController.swift
//  Todoey
//
//  Created by MohammedAyman on 5/22/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework



class TodoListViewController: SwipeTableViewController {
    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategroy :Category?{
        didSet{
            loadItems()
        }
    }
    
    @IBOutlet weak var itemsSearchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        if let UIColor = UIColor(hexString: selectedCategroy!.hexColor),let navBar = navigationController?.navigationBar {
            title = selectedCategroy?.name
            navBar.backgroundColor = UIColor
            itemsSearchBar.barTintColor = UIColor
            navBar.tintColor = ContrastColorOf(UIColor, returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:ContrastColorOf(UIColor, returnFlat: true)]
        }
      }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    //MARK: - TableView Datasourse Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
            
            if let darkenColor = UIColor(hexString: selectedCategroy!.hexColor)?.darken(byPercentage: CGFloat( indexPath.row) / CGFloat( todoItems!.count)){
                cell.backgroundColor = darkenColor
                cell.textLabel?.textColor = ContrastColorOf(darkenColor, returnFlat: true)
            }
            
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    // realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print(error)
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            if let currentCategory = self.selectedCategroy{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.date = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print(error)
                }
            }
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            textField.returnKeyType = .go
        }
        
    }
    
    func loadItems() {
        
        todoItems = selectedCategroy?.items.sorted(byKeyPath: "title", ascending: true)
        
        
        tableView.reloadData()
    }
    
    //MARK: - delete data
    
    override func updateModel(at indexPath: IndexPath) {
        if let deleteTodoItems = self.todoItems?[indexPath.row]{
            do {
                try self.realm.write{
                    self.realm.delete(deleteTodoItems)
                }
            }catch{
                print(error)
            }
            
        }
    }
    
}




//MARK: - UISearchBarDelegate

extension TodoListViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems =  todoItems?.filter( "title CONTAINS[cd] %@" , searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {searchBar.resignFirstResponder()}
            
        }else{
            todoItems =  todoItems?.filter( "title CONTAINS[cd] %@" , searchBar.text!).sorted(byKeyPath: "title", ascending: true)
          
            tableView.reloadData()
        }
       
    }
    
 
}

