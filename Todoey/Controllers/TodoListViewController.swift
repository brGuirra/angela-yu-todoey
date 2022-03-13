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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Tasks.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath! )
      
        loadTasks()
    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = task.title
        cell.accessoryType =  task.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentIndex = indexPath.row
        
        tasks[currentIndex].done.toggle()
        
        saveTasks()
        
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
             
             self?.saveTasks()
             
             self?.tableView.reloadData()
         }))
         
         present(ac, animated: true)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveTasks() {
        guard let dataFilePath = dataFilePath else { return }
        let enconder = PropertyListEncoder()
        
        do {
            let savedTasks = try enconder.encode(tasks)
            try savedTasks.write(to: dataFilePath)
        } catch {
            print("Failed saving tasks: \(error)")
        }
    }
    
    func loadTasks() {
        guard let dataFilePath = dataFilePath else { return }
        
        if let data = try? Data(contentsOf: dataFilePath) {
            print("passou aqui")
            
            let decoder = PropertyListDecoder()
            
            do {
                tasks = try decoder.decode([Task].self, from: data)
            } catch {
                print("Failed loading tasks: \(error)")
            }
        }
    }
}

