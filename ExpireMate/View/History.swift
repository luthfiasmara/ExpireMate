//
//  History.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 27/04/23.
//

import SwiftUI

struct History: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)]) var itemsku: FetchedResults<Item>
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack {
                    List {
                        HStack{
                            Text("History")
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        ForEach(itemsku) { itm in
                            if itm.isExpired{
                                VStack(alignment: .leading){
                                    Text(itm.name ?? "Unknown name")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    HStack{
                                        Text("Expired on \(dateString(date: itm.end_date ?? Date(), format: "dd MMMM yyyy - HH:mm"))")
                                            .font(.callout)
                                            .italic()
                                        
                                    }
                                    
                                    Text(itm.isExpired ? "Past expiry date" : "Not yet expired")
                                        .font(.caption)
                                        .foregroundColor(itm.isExpired ? .red : .green)
                                    
                                    
                                    
                                }
                                .onAppear {
                                    
                                    let center = UNUserNotificationCenter.current()
                                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute ], from: itm.end_date ?? Date())
                                    
                                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                                    
                                    // Create the notification content
                                    let content = UNMutableNotificationContent()
                                    content.title = "Reminder"
                                    content.body = "Your \(itm.name ?? "") expired today"
                                    
                                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                                    
                                    // Schedule the notification
                                    center.add(request)
                                }
                            }
                        }.onDelete(perform: deleteItem)
                    }
                }
            }
        }
        
        
        
        
    }
    func dateString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    func deleteItem(offsets: IndexSet) {
        withAnimation {
            offsets.map { itemsku[$0] }
                .forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
    }
}
