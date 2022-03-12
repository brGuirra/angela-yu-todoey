//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var tasks = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if let savedTasks = defaults.array(forKey: "tasks") as? [String] {
            tasks = savedTasks
        }
    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = task
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items    
    
     @IBAction func addTaksPressed(_ sender: UIBarButtonItem) {
         let ac = UIAlertController(title: "Add a task", message: nil, preferredStyle: .alert)
         
         ac.addTextField { (textField) in
             textField.placeholder = "Create new item"
         }
         
         ac.addAction(UIAlertAction(title: "Add item", style: .default, handler: { [weak self] (action) in
             guard let newTask = ac.textFields?[0].text else { return }
             
             self?.tasks.append(newTask)
             
             let defaults = UserDefaults.standard
             defaults.set(self?.tasks, forKey: "tasks")
             
             self?.tableView.reloadData()
         }))
         
         present(ac, animated: true)
    }
}

