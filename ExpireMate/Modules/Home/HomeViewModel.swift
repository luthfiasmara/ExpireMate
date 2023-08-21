//
//  HomeViewModel.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 16/08/23.
//

import Foundation
import CoreData

class HomeViewModel: ObservableObject {
    
    @Published var notYetExpired: Int = 0
    @Published var hasExpired: Int = 0
    @Published var points: Int = 0
    @Published var fetchedResults: [Item] = []
    @Published var records: [ItemListing] = []
    

    init() {
            fetchData()
        print(records)
        }

    
    func fetchData() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)]
        
        
        do {
            fetchedResults = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            let records = fetchedResults.map { item in
                ItemListing(name: item.name ?? "", startDate: item.start_date ?? Date(), endDate: item.end_date ?? Date(), isExpired: item.isExpired)
            }
            self.records = records
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
    
    func dateString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
//    func countTrueData() -> Int {
//        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "isExpired == %@", NSNumber(value: true))
//
//        do {
//            let result = try CoreDataStack.shared.context..count(for: fetchRequest)
//            print(result)
//            self.hasExpired = result
//            return result
//        } catch {
//            print("Error counting true data: \(error.localizedDescription)")
//            return 0
//        }
//    }
//    func countFalseData() -> Int {
//        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "isExpired == %@", NSNumber(value: false))
//
//        do {
//            let result = try managedObjContext.count(for: fetchRequest)
//            print("aaaa \(result)")
//            self.notYetExpired = result
//            return result
//
//
//
//        } catch {
//            print("Error counting true data: \(error.localizedDescription)")
//            return 0
//        }
//    }
    
    func deleteItem(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { itemList[$0] }
//                .forEach(managedObjContext.delete)
//            DataController().save(context: managedObjContext)
//        }
    }

    
    
    

}
