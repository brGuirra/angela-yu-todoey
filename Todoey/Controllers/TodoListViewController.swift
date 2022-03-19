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

    var tasks: Results<Task>?

    var selectedCategory: Category? {
        didSet {
//            loadTasks() 
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .white

        searchBar.delegate = self
    }

    //MARK: - TableView DataSource Methods

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tasks.count
//    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let task = tasks[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoTaskCell", for: indexPath)
//
//        cell.textLabel?.text = task.title
//        cell.accessoryType =  task.done ? .checkmark : .none
//
//        return cell
//    }

    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let currentIndex = indexPath.row
//
//        tasks[currentIndex].done.toggle()
//
//        save()
//
//        tableView.cellForRow(at: indexPath)?.accessoryType =  tasks[currentIndex].done ? .checkmark : .none
//
//        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - Add New Task

     @IBAction func addTaksPressed(_ sender: UIBarButtonItem) {
//         let ac = UIAlertController(title: "Add a task", message: nil, preferredStyle: .alert)
//
//         ac.addTextField { (textField) in
//             textField.placeholder = "Create new task"
//         }
//
//         ac.addAction(UIAlertAction(title: "Add item", style: .default, handler: { [weak self] (action) in
//             guard let self = self else { return }
//             guard let taskTitle = ac.textFields?[0].text else { return }
//
//             let newTask = Task()
//             newTask.title = taskTitle
//             newTask.done = false
//
//             self.save(task: newTask)
//
//             self.tableView.reloadData()
//         }))
//
//         present(ac, animated: true)
    }

    //MARK: - Model Manipulation Methods

    func save(task: Task) {
        
    }

//    func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil) {
//        guard let categoryName = selectedCategory?.name else {
//            return
//        }
//
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", categoryName)
//
//        if let aditionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, aditionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//           tasks =  try context.fetch(request)
//        } catch {
//            print("Error fetching tasks: \(error)")
//        }
//    }
}

//MARK: - UISearchBar Delegate

extension TodoListViewController: UISearchBarDelegate {

//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if let value = searchBar.text {
//            let request: NSFetchRequest<Task> = Task.fetchRequest()
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", value)
//
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//            loadTasks(with: request, predicate: predicate)
//
//            tableView.reloadData()
//        }
//    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadTasks()
//
//            tableView.reloadData()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
    }
}

