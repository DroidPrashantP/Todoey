//
//  ViewController.swift
//  Todoey
//
//  Created by Prashant Patil on 7/13/20.
//  Copyright © 2020 Prashant Patil. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Note]()
    var userDefault = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todoListItemFromDB = userDefault.array(forKey: "TodoListArray") as? [Note] {
            self.itemArray = todoListItemFromDB
        }
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
    
        cell.accessoryType = item.done ? .checkmark : .none
        
        self.tableView.reloadData()
        return cell
    }
    
    //Mark -  Add button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var itemTextField = UITextField()
        let alertDialog = UIAlertController.init(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            let newItem = Note()
            newItem.title = itemTextField.text!
            self.itemArray.append(newItem)
            
            self.userDefault.set(self.itemArray, forKey: "TodoListArray") as! [Note]
            self.tableView.reloadData()
        }
        
        alertDialog.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            itemTextField = alertTextField
        }
        
        alertDialog.addAction(action)
        present(alertDialog, animated: true, completion: nil)
    }
}

