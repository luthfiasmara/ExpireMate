//
//  AddItems.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 25/04/23.
//

import SwiftUI
import UserNotifications
import CloudKit


struct AddItems: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    @StateObject var calendarManager = CalendarManager()
   
    @State private var showErrorAlert = false
    
    @State private var category = ItemCategory.fruits


    @State var name = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var nowDate: Date = Date()
    @State var isExpired: Bool = false
   
    var body: some View {
        Form{
            Section{
                TextField("Nama Produk", text: $name)
                DatePicker(
                    "Start Date",
                    selection: $startDate,
                    displayedComponents: [.date]
                )
                DatePicker(
                    "End Date", selection: $endDate,
                           displayedComponents: [.date, .hourAndMinute]
                )
                
//                CategoryPicker(category: $category)

                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button {
                            print(category)
                            DataController().addItems(name: name, start_date: startDate, end_date: endDate, isExpired: isExpired, timestamp: nowDate, category: "-", context: managedObjContext)
//                            vm.saveItem(name: name, startDate: startDate, endDate: endDate, isExpired: isExpired)
                            
                            let items = ExpireItem(name: name, expirationDate: endDate)
                            calendarManager.requestAccess { granted in
                                if granted {
                                    calendarManager.addEvent(items: items) { success, error in
                                        if success {
                                            print("Event added to calendar.")
                                        } else {
                                            print("Error adding event to calendar: \(error?.localizedDescription ?? "")")
                                            showErrorAlert = true
                                        }
                                    }
                                } else {
                                    print("Access denied to calendar.")
                                    showErrorAlert = true
                                }
                            }
                            

                            dismiss()
                        } label: {
                            Text("Save")
                                .foregroundColor(.white)
                                .frame(width: 100, height: 35)
                                .background(.blue)
                                .cornerRadius(5)
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text("Failed to add event to calendar."), dismissButton: .default(Text("OK")))
        }
    }
}

struct AddItems_Previews: PreviewProvider {
    static var previews: some View {
        AddItems()
    }
}
