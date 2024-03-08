//
//  ViewController.swift
//  dataPersistanceMiniApp
//
//  Created by Jonah Whitney on 3/6/24.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Data for the table
    var items: [Wine]?

    @IBOutlet weak var tableView: UITableView!
    
    
    // setting up button to add data when tapped
    @IBAction func addWineTapped(_ sender: UIButton) {
        
        // create pop up to take info
        let alert = UIAlertController(title: "Add new wine", message: "Wine name, color, type, and quantity", preferredStyle: .alert)

        // make 4 text field entries with placeholder text for prompts
        alert.addTextField(configurationHandler: { field in
            field.placeholder = "Wine name"
        })
        alert.addTextField(configurationHandler: { field in
            field.placeholder = "Color"
        })
        alert.addTextField(configurationHandler: { field in
            field.placeholder = "Type"
        })
        alert.addTextField(configurationHandler: { field in
            field.placeholder = "Quantity"
        })
        
        // make the buttons on the alert
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submit = UIAlertAction(title: "Add", style: .default, handler: { action in
            
            // get the entered data
            let name = alert.textFields![0]
            let color = alert.textFields![1]
            let type = alert.textFields![2]
            let quantity = alert.textFields![3]
            
            // create wine object
            let newWine = Wine(context: self.context)
            newWine.name = name.text
            newWine.color = color.text
            newWine.type = type.text
            newWine.quantity = Int64(quantity.text!) ?? 1
            
            // save the data
            do {
                try self.context.save()
            }
            catch {
                print("error saving the data")
            }
            // re-fetch the data
            self.fetchWine()
            
        })
        alert.addAction(cancel)
        alert.addAction(submit)
        
        self.present(alert, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchWine()
    }
    
    // method that will be reused to refresh wine data
    func fetchWine () {
        
        // Fetch the data from core data to display in the tableView
        do {
            self.items = try context.fetch(Wine.fetchRequest())
            
            // reload the table with new data that is added
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        catch {
            print("Error retrieving data.")
        }
        
    }
    
    // method for deleting a wine
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, completionHandler) in
        
            // select wine to remove
            let wineToDelete = self.items![indexPath.row]
            
            // remove the wine
            self.context.delete(wineToDelete)
            
            // save the data
            do {
                try self.context.save()
            }
            catch {
                print("Error deleting data.")
            }
            
            // re-fetch the data
            self.fetchWine()
            
            
        })
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // method for updating wine info
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Edit Wine Information", handler: { (action, view, completionHandler) in
            
            // select wine to update
            let wine = self.items![indexPath.row]
            
            // create alert to take updated info
            let alert = UIAlertController(title: "Edit Wine Info", message: "Enter new information", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: { field in
                field.placeholder = "Wine name"
            })
            alert.addTextField(configurationHandler: { field in
                field.placeholder = "Color"
            })
            alert.addTextField(configurationHandler: { field in
                field.placeholder = "Type"
            })
            alert.addTextField(configurationHandler: { field in
                field.placeholder = "Quantity"
            })
            
            // make the buttons on alert
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let submit = UIAlertAction(title: "Add", style: .default, handler: { action in
                
                // get the entered data
                let name = alert.textFields![0]
                let color = alert.textFields![1]
                let type = alert.textFields![2]
                let quantity = alert.textFields![3]
                
                // edit selected wine
                wine.name = name.text
                wine.color = color.text
                wine.type = type.text
                wine.quantity = Int64(quantity.text!) ?? 1
                
                // save the data
                do {
                    try self.context.save()
                }
                catch {
                    print("error saving the data")
                }
                // re-fetch the data
                self.fetchWine()
                
            })
            alert.addAction(cancel)
            alert.addAction(submit)
            
            self.present(alert, animated: true)
            
            
        })
        
        // make background of action blue?
        action.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    // methods for setting up tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "wineCell", for: indexPath)
        
        // get wine from items and set label
        let wine = self.items![indexPath.row]
        
        cell.textLabel?.text = "\(wine.name!) \(wine.type!) - \(wine.color!), QTY: \(wine.quantity)"
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    

}

