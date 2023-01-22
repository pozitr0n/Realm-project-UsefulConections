//
//  Model.swift
//  Realm-UsefulConnections
//
//  Created by Raman Kozar on 09/01/2023.
//

import Foundation
import RealmSwift

class ConnectionsModel: Object {
    
    @objc dynamic var userID = 0
    @objc dynamic var userEmail = ""
    @objc dynamic var userDescription = ""
    @objc dynamic var userRating = ""
        
    func getCountFromDatabase() -> Int {
        
        let realm = try! Realm()
        realm.refresh()
        
        let array = realm.objects(ConnectionsModel.self).toArray(ofType: ConnectionsModel.self)
        return array.count > 0 ? array.count : 0
        
    }
    
    func getObjectsBySelection(currRow: Int) -> ConnectionsModel {
        
        let realm = try! Realm()
        realm.refresh()
        
        guard let connection = realm.objects(ConnectionsModel.self).filter("userID == %@", currRow).first else { return ConnectionsModel() }
        return connection
        
    }
    
    func addNewObjectIntoCollection(_ emailTextField: String, _ descriptionTextField: String, _ ratingTextField: String) {
    
        let realm = try! Realm()
        
        let connection = ConnectionsModel()
        connection.userEmail = emailTextField
        connection.userRating = ratingTextField
        connection.userDescription = !descriptionTextField.isEmpty ? descriptionTextField : ""
        
        let conutOfObjects = getCountFromDatabase()
        connection.userID = conutOfObjects
        
        do {
            
            try realm.write{
                realm.add(connection)
                realm.refresh()
            }
            
        } catch let error as NSError {
            print("error - \(error.localizedDescription)")
        }
        
    }
    
    func updateNewObjectIntoCollection(_ emailTextField: String, _ descriptionTextField: String, _ ratingTextField: String, _ currRow: Int) {
    
        let realm = try! Realm()
        realm.refresh()
        
        let connection = realm.objects(ConnectionsModel.self).filter("userID == %@", currRow)
        
        if let currConnection = connection.first {
            
            do {
            
                try realm.write {
                    currConnection.userEmail = emailTextField
                    currConnection.userRating = ratingTextField
                    currConnection.userDescription = descriptionTextField
                }
                
            } catch let error as NSError {
                print("error - \(error.localizedDescription)")
            }
            
        }
    
    }
    
    func deleteObjectFromCollection(_ currRow: Int) {
    
        let realm = try! Realm()
        realm.refresh()
        
        do {
            
            if let connection = realm.objects(ConnectionsModel.self).filter("userID == %@", currRow).first {
                
                try realm.write {
                    realm.delete(connection)
                }
            }
            
        } catch let error as NSError {
            print("error - \(error.localizedDescription)")
        }
        
    }
    
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        let array = Array(self) as! [T]
        return array
    }
}
