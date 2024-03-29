//
//  TodoViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ItemArray.plist")
    
    override func viewDidLoad() {
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem1 = Item()
        newItem1.title = "Kill Dememorgon"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "Get Eleven's attention"
        itemArray.append(newItem2)
        
        loadItems()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCellIdentifier, for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
        } else {
            cell.textLabel!.text = item.title
        }
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done.toggle()
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add task", style: .default) { action in
            //            guard let textField = alert.textFields?.first, let text = textField.text
            //            else {
            //                print("I have nothing")
            //                return
            //            }
            //
            //            print("New task: \(text), added")
            
            let anItem = Item()
            anItem.title = textField.text!
            
            self.itemArray.append(anItem)
                
            self.saveItems()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "What are you up to?"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: url!)
        } catch {
            print("Error encodign and saving data, \(error)")
        }

        tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: url!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding data, \(error)")
            }
        }
    }
}

