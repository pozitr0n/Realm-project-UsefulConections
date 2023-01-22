//
//  TableViewController.swift
//  Realm-UsefulConnections
//
//  Created by Raman Kozar on 08/01/2023.
//

import UIKit
//import RealmSwift

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //let realm = try! Realm()
        
        //let allUploadingObjects = realm.objects(ConnectionsModel.self)

        //try! realm.write {
        //    realm.delete(allUploadingObjects)
        //}
        
        //print(realm.configuration.fileURL)
        
        tableView.delegate = self
        tableView.dataSource = self

    }

    @IBAction func addTheNote(_ sender: Any) {
        
        let customAlert = CustomAlert()
        customAlert.updateAllTheData = self
        customAlert.isNew = true
        customAlert.showAlert(currRow: nil)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConnectionsModel().getCountFromDatabase()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let customAlert = CustomAlert()
        customAlert.updateAllTheData = self
        customAlert.isNew = false
        customAlert.showAlert(currRow: indexPath.row)
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let currCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell
        else {
            return UITableViewCell()
        }
                
        currCell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let currRow = indexPath.row
        currCell.insertDataIntoCell(dataInfo: ConnectionsModel().getObjectsBySelection(currRow: currRow))
        
        return currCell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            ConnectionsModel().deleteObjectFromCollection(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            tableView.reloadData()
            
        }
    }
    
}

extension TableViewController: UpdateAllTheData {
    
    func updateAllTheData() {
        tableView.reloadData()
    }
    
}

