//
//  HistoryViewModel.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 22/08/23.
//

import Foundation
import CoreData
import NotificationCenter

class HistoryViewModel: ObservableObject{
    
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
    
    func dateString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    //    func deleteItem(offsets: IndexSet) {
    //        withAnimation {
    //            offsets.map { itemsku[$0] }
    //                .forEach(managedObjContext.delete)
    //            DataController().save(context: managedObjContext)
    //        }
    //    }
}
