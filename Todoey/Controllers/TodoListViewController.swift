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
    @IBOutlet weak var searchBar: UISearchBar!
    
    var tasks: [Task] = []
    
    let userDefaultKey = "tasks"
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Tasks.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    
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
             guard let self = self else { return }
             guard let taskTitle = ac.textFields?[0].text else { return }
             
             let newTask = Task(context: self.context)
             newTask.title = taskTitle
             newTask.done = false
             self.tasks.append(newTask)
             
             self.saveTasks()
             
             self.tableView.reloadData()
         }))
         
         present(ac, animated: true)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveTasks() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest()) {
        do {
           tasks =  try context.fetch(request)
        } catch {
            print("Error fetching tasks from context: \(error)")
        }
    }
}

//MARK: - UISearchBar Delegate

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let value = searchBar.text {
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", value)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadTasks(with: request)
            
            tableView.reloadData()
        }
    }
}

