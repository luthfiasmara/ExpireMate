//
//  Calendar.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 07/05/23.
//

import SwiftUI
import EventKit

struct ExpireItem: Codable {
    let name: String
    let expirationDate: Date
}

class CalendarManager: NSObject, ObservableObject {
    let eventStore = EKEventStore()
    
    func requestAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .event) { (granted, error) in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func addEvent(items: ExpireItem, completion: @escaping (Bool, Error?) -> Void) {
        let event = EKEvent(eventStore: eventStore)
        event.title = "Kadaluarsa Makanan: \(items.name)"
        event.startDate = items.expirationDate
        event.endDate = items.expirationDate
        event.notes = "Makanan yang sudah kadaluarsa"
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            completion(true, nil)
        } catch let error {
            completion(false, error)
        }
    }
}


