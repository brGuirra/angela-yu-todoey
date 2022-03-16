//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Bruno Guirra on 15/03/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories: [Category] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            let newCategory = Category(context: self.context)
            newCategory.name = categoryName
            self.categories.append(newCategory)
            
            self.saveCategories()
            
            self.tableView.reloadData()
        }))
        
        present(ac, animated: true)
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    //MARK: - Add New Category
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving categories: \(error)")
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching categories: \(error)")
        }
    }
    
    //MARK: - Data Manipulation Methods
}
