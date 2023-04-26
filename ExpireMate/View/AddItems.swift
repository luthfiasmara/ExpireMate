//
//  AddItems.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 25/04/23.
//

import SwiftUI
import UserNotifications


struct AddItems: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State var name = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var nowDate: Date = Date()
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

                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button {
                            DataController().addItems(name: name, start_date: startDate, end_date: endDate, timestamp: nowDate, context: managedObjContext)
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
    }
}

struct AddItems_Previews: PreviewProvider {
    static var previews: some View {
        AddItems()
    }
}
