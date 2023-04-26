//
//  DataController.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 25/04/23.
//

import Foundation
import CoreData

class DataController: ObservableObject{
    
    let container = NSPersistentContainer(name: "ExpireMate")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print ("failed to load data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext){
        do {
            try context.save()
            print("data saved!")
        } catch {
            print("could not save the data...")
        }
    }
    
    func addItems(name: String, start_date: Date, end_date: Date, timestamp: Date, context: NSManagedObjectContext){
        let item = Item(context: context)
        item.id = UUID()
        item.name = name
        item.start_date = start_date
        item.end_date = end_date
        item.timestamp = timestamp
        
        save(context: context)
        
    }
}
