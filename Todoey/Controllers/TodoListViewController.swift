//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()

    var tasks: Results<Task>?

    var selectedCategory: Category? {
        didSet {
            load()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .white
        
        searchBar.delegate = self
    }

    //MARK: - TableView DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoTaskCell", for: indexPath)
        
        if let tasks = tasks {
            let task = tasks[indexPath.row]
            
            cell.textLabel?.text = task.title
            cell.accessoryType =  task.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No tasks added yet"
        }
        
        return cell
    }

    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentIndex = indexPath.row
        
        if let task = tasks?[currentIndex] {
            update(task)
            
            tableView.reloadData()
        }
    }

    //MARK: - Add New Task

     @IBAction func addTaksPressed(_ sender: UIBarButtonItem) {
         let ac = UIAlertController(title: "Add a task", message: nil, preferredStyle: .alert)

         ac.addTextField { (textField) in
             textField.placeholder = "Create new task"
         }

         ac.addAction(UIAlertAction(title: "Add item", style: .default, handler: { [weak self] (action) in
             guard let self = self else { return }
             guard let taskTitle = ac.textFields?[0].text else { return }
             
             
             let newTask = Task()
             newTask.title = taskTitle
             newTask.createdAt = Date()
             
             self.save(task: newTask)
             
             self.tableView.reloadData()
             
         }))

         present(ac, animated: true)
    }

    //MARK: - Model Manipulation Methods

    func save(task: Task?) {
        if let task = task, let category = selectedCategory {
            do {
                try realm.write({
                    category.tasks.append(task)
                })
            } catch {
                print("Error saving tasks: \(error)")
            }
        }
    }

    func load() {
        tasks = selectedCategory?.tasks.sorted(byKeyPath: "title", ascending: true)
    }
    
    func update(_ task: Task) {
        do {
            try realm.write {
                task.done.toggle()
            }
        } catch {
            print("Error updating done status: \(error)")
        }
    }
}

//MARK: - UISearchBar Delegate

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let value = searchBar.text {
            tasks = tasks?.filter("title CONTAINS[cd] %@", value).sorted(byKeyPath: "createdAt", ascending: true)

            tableView.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            load()

            tableView.reloadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

