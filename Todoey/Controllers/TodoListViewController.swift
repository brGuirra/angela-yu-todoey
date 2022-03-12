//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var tasks: [Task] = []
    
    let userDefaultKey = "tasks"
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedTasks = defaults.object(forKey: userDefaultKey) as? Data {
            let decoder = JSONDecoder()
          
            do {
                tasks = try decoder.decode([Task].self, from: savedTasks)
            } catch {
                print("Failed retrieving saved tasks.")
            }
           
        }
    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = task.title
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentIndex = indexPath.row
        
        tasks[currentIndex].done.toggle()
        
        tableView.cellForRow(at: indexPath)?.accessoryType =  tasks[currentIndex].done ? .checkmark : .none
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items    
    
     @IBAction func addTaksPressed(_ sender: UIBarButtonItem) {
         let ac = UIAlertController(title: "Add a task", message: nil, preferredStyle: .alert)
         
         ac.addTextField { (textField) in
             textField.placeholder = "Create new item"
         }
         
         ac.addAction(UIAlertAction(title: "Add item", style: .default, handler: { [weak self] (action) in
             guard let taskTitle = ac.textFields?[0].text else { return }
             
             let newTask = Task(title: taskTitle)
             self?.tasks.append(newTask)
             
             self?.saveTask()
             
             self?.tableView.reloadData()
         }))
         
         present(ac, animated: true)
    }
    
    func saveTask() {
        let enconder = JSONEncoder()
        
        if let savedTasks = try? enconder.encode(tasks) {
            defaults.set(savedTasks, forKey: userDefaultKey)
        } else {
            print("Failed to save tasks.")
        }
    }
}

