//
//  HomeViewModel.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 16/08/23.
//

import SwiftUI
import CoreData
import NotificationCenter

enum PageState{
    case loading
    case success
    case error
}

class HomeViewModel: ObservableObject {
    
    @Published var notYetExpired: Int = 0
    @Published var hasExpired: Int = 0
    @Published var points: Int = 0
    @Published var showAddView: Bool = false
    @Published var fetchedResults: [Item] = []
    @Published var records: [ItemListing] = []
    
    @Published var status : PageState = .loading
    
    
    private let coreDataManager = CoreDataManager()

//    init() {
//            fetchData()
////        print(records)
//        }

    
    func fetchData() {
        print("aaaaa")
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)]
        
        
        do {
            self.status = .loading
            fetchedResults = try coreDataManager.viewContext.fetch(fetchRequest)
            let records = fetchedResults.map { item in
                ItemListing(name: item.name ?? "", startDate: item.start_date ?? Date(), endDate: item.end_date ?? Date(), isExpired: item.isExpired)
            }
            
            self.records = records
            self.status = .success
            print("ini recordnya: \(records)")
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            status = .error
        }
    }
    
    func dateString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func countTrueData() -> Int {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isExpired == %@", NSNumber(value: true))

        do {
            let result = try coreDataManager.viewContext.count(for: fetchRequest)
            print(result)
            self.hasExpired = result
            return result
        } catch {
            print("Error counting true data: \(error.localizedDescription)")
            return 0
        }
    }
    func countFalseData() -> Int {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isExpired == %@", NSNumber(value: false))

        do {
            let result = try coreDataManager.viewContext.count(for: fetchRequest)
            print("aaaa \(result)")
            self.notYetExpired = result
            print("jumlah notYet : \(result)")
            return result



        } catch {
            print("Error counting true data: \(error.localizedDescription)")
            return 0
        }
    }
    
//    func deleteItem(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { records[$0] }
//                .forEach(coreDataManager.viewContext.delete)
//            coreDataManager().save(context: coreDataManager.viewContext)
//        }
//    }
    
    func notificationAlert(item: ItemListing){
        let center = UNUserNotificationCenter.current()
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute ], from: item.endDate )
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Your \(item.name ) expired today"
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Schedule the notification
        center.add(request)
    }

    
    
    

}
