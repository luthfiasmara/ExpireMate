//
//  Home.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 25/04/23.
//

import SwiftUI
import UserNotifications


struct Home: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)]) var itemsku: FetchedResults<Item>
//    @StateObject private var vm = AppViewModel()

    @State private var showingAddView = false
    @State var showingScanner = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack {
                    
                    
                    List {
                        ForEach(itemsku) { itm in
                    
                            VStack(alignment: .leading){
                                Text(itm.name!)
                                Text("Expired on \(dateString(date: itm.end_date!, format: "dd MMMM yyyy"))")
                                
                            }
                                .onAppear {
//                                                                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//                                                                            if success {
//                                                                                print("All set!")
//                                                                            } else if let error = error {
//                                                                                print(error.localizedDescription)
//                                                                            }
//                                                                        }
//
                                    let center = UNUserNotificationCenter.current()
                                    let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute ], from: itm.end_date!)
                                    
                                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                                    
                                    // Create the notification content
                                    let content = UNMutableNotificationContent()
                                    content.title = "Reminder"
                                    content.body = "Your \(itm.name!) expired today"
                                    //                                    content.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
                                    
                                    // Create the notification request
                                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                                    
                                    // Schedule the notification
                                    center.add(request)
                                }
                            
                            
                        }.onDelete(perform: deleteItem)
                        
                        
                    }
                    
                    
                    
                    
                    
                }.toolbar {
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddView.toggle()
                        } label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                            //
                            
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingScanner.toggle()
                        } label: {
                            Image(systemName: "barcode")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                        }
                    }
                    
                }
                .sheet(isPresented: $showingAddView) {
                    AddItems()
                }
                .sheet(isPresented: $showingScanner) {
//                                DataScannerView()
                            }
            }.background(.white)
        }
        
    }
    func dateString(date: Date, format: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: date)
        }
    
    private func deleteItem(offsets: IndexSet) {
        withAnimation {
            offsets.map { itemsku[$0] }
                .forEach(managedObjContext.delete)
            
            // Saves to our database
            DataController().save(context: managedObjContext)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

