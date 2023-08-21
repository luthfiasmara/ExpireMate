//
//  DataController.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 25/04/23.
//

import Foundation
import CoreData

class DataController: ObservableObject{
//    @Published var itemExp = [Item]()
    

    let container = NSPersistentContainer(name: "ExpireMate")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print ("failed to load data \(error.localizedDescription)")
            }
        }
    }
    
//    func fetchData(context: NSManagedObjectContext) {
//        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
//        do {
//            try context.fetch(fetchRequest)
//        } catch {
//            print("Error fetching tasks: \(error.localizedDescription)")
//        }
//    }
    
    

    
    func save(context: NSManagedObjectContext){
        do {
            try context.save()
            print("data saved!")
        } catch {
            print("could not save the data...")
        }
    }
    
    func addItems(name: String, start_date: Date, end_date: Date, isExpired: Bool, timestamp: Date, category: String, context: NSManagedObjectContext){
        let item = Item(context: context)
        item.id = UUID()
        item.name = name
        item.start_date = start_date
        item.end_date = end_date
        item.isExpired = isExpired
        item.category = category
        item.timestamp = timestamp
        
        save(context: context)
        
    }
    
    func editItems(isExpired: Bool, context: NSManagedObjectContext){
        let item = Item(context: context)
        item.isExpired = isExpired
        save(context: context)
    }
    
    func checkStatusAndUpdate(context: NSManagedObjectContext) {
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            
            do {
                let items = try context.fetch(fetchRequest)
                let count = try context.count(for: fetchRequest)
                print(count)
                for itm in items {
                    if itm.end_date ?? Date() < Date() {
                        itm.isExpired = true
                        save(context: context)
                    }
                }
                try context.save()
            } catch {
                print("Error checking status and updating: \(error.localizedDescription)")
            }
        }
    
    
}
