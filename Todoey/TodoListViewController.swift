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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ItemList.plist")
           
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(dataFilePath)
        loadData()
    
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
    
        cell.accessoryType = item.done ? .checkmark : .none
       
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
            self.saveItem()
        }
        
        alertDialog.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            itemTextField = alertTextField
        }
        
        alertDialog.addAction(action)
        present(alertDialog, animated: true, completion: nil)
    }
    
    func saveItem() {
    
        let encoder = PropertyListEncoder()
          do {
              let data = try encoder.encode(itemArray)
              try data.write(to: self.dataFilePath!)
          } catch {
              print("Error encoding item array, \(error)")
          }
          self.tableView.reloadData()
    }
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
    
            do {
                itemArray = try decoder.decode([Note].self, from: data)
            } catch {
                print("Error decoding the itemArray\(error)")
            }
        }
    }
}

