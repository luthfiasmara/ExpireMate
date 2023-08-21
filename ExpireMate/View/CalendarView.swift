//
//  Calendar.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 07/05/23.
//

import SwiftUI
import EventKit

struct CalendarView: View {
    @StateObject var calendarManager = CalendarManager()
    @State private var name = ""
    @State private var expirationDate = Date()
    @State private var showErrorAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Nama Makanan", text: $name)
                    DatePicker("Tanggal Kadaluarsa", selection: $expirationDate)
                }
                Section {
                    Button("Tambahkan ke Kalender") {
                        let items = ExpireItem(name: name, expirationDate: expirationDate)
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
                    }
                }
            }
            .navigationBarTitle("Pengingat Kadaluarsa Makanan")
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text("Failed to add event to calendar."), dismissButton: .default(Text("OK")))
        }
    }
}

