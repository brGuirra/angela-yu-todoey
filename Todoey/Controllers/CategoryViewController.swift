//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Bruno Guirra on 15/03/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        
        loadCategories()
    }
    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Add category", message: nil, preferredStyle: .alert)
        
        ac.addTextField { (textField) in
            textField.placeholder = "Create a new category"
        }
        
        ac.addAction(UIAlertAction(title: "Add item", style: .default, handler: { [weak self] (action) in
            guard let self = self else { return }
            guard let categoryName = ac.textFields?[0].text else { return }
            
            let newCategory = Category()
            newCategory.name = categoryName
            
            self.save(category: newCategory)
            
            self.tableView.reloadData()
        }))
        
        present(ac, animated: true)
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories?[indexPath.row]
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = category?.name ?? "No categories added yet"
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToTasks", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error saving categories: \(error)")
        }
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
    }
    
    func deleteCategory(_ category: Category) {
        do {
            try realm.write({
                realm.delete(category)
            })
        } catch {
            print("Error deleting category: \(error)")
        }
    }
    
    override func updateModel(up indexPath: IndexPath) {
        if let category = categories?[indexPath.row] {
            deleteCategory(category)
        }
    }
}
