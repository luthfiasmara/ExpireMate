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
//    @Environment(\.managedObjectContext) var managedObjContext
//    @Environment(\.dismiss) var dismiss
//    @StateObject var calendarManager = CalendarManager()
//
//
//    @State private var category = ItemCategory.fruits
@StateObject var addItemVM = AddItemViewModel()

    
   
    var body: some View {
        Form{
            Section{
                TextField("Nama Produk", text: $addItemVM.name)
                DatePicker(
                    "Start Date",
                    selection: $addItemVM.startDate,
                    displayedComponents: [.date]
                )
                DatePicker(
                    "End Date", selection: $addItemVM.endDate,
                           displayedComponents: [.date, .hourAndMinute]
                )
                
//                CategoryPicker(category: $category)

//                VStack{
//                    Spacer()
//                    HStack{
//                        Spacer()
//                        Button {
//                            print(category)
//                            AddItemViewModel().addItems(name: addItemVM.name, start_date: addItemVM.startDate, end_date: addItemVM.endDate, isExpired: addItemVM.isExpired, timestamp: addItemVM.nowDate, category: "-", context: managedObjContext)
////                            vm.saveItem(name: name, startDate: startDate, endDate: endDate, isExpired: isExpired)
//
//                            let items = ExpireItem(name: addItemVM.name, expirationDate: addItemVM.endDate)
//                            calendarManager.requestAccess { granted in
//                                if granted {
//                                    calendarManager.addEvent(items: items) { success, error in
//                                        if success {
//                                            print("Event added to calendar.")
//                                        } else {
//                                            print("Error adding event to calendar: \(error?.localizedDescription ?? "")")
//                                            showErrorAlert = true
//                                        }
//                                    }
//                                } else {
//                                    print("Access denied to calendar.")
//                                    showErrorAlert = true
//                                }
//                            }
//
//
//                            dismiss()
//                        } label: {
//                            Text("Save")
//                                .foregroundColor(.white)
//                                .frame(width: 100, height: 35)
//                                .background(.blue)
//                                .cornerRadius(5)
//                        }
//                        Spacer()
//                    }
//                    Spacer()
//                }
            }
        }
        .alert(isPresented: $addItemVM.showErrorAlert) {
            Alert(title: Text("Error"), message: Text("Failed to add event to calendar."), dismissButton: .default(Text("OK")))
        }
    }
}

struct AddItems_Previews: PreviewProvider {
    static var previews: some View {
        AddItems()
    }
}
