//
//  ItemListing.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 23/05/23.
//

import SwiftUI
import CloudKit

class ItemsListing: ObservableObject {
    @Published var lists: [ItemListing] = []
}
struct ItemListing: Identifiable , Hashable{
    var id: CKRecord.ID?
    var name: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date()
    var isExpired: Bool = false
    
//    init(recordId: CKRecord.ID? = nil, name: String, startDate: Date, endDate: Date, isExpired: Bool) {
//        self.recordId = recordId
//        self.name = name
//        self.startDate = startDate
//        self.endDate = endDate
//        self.isExpired = isExpired
//    }
    func toDictionary() -> [String: Any]{
        return ["name": name, "startDate": startDate, "endDate": endDate, "isExpired": isExpired]
    }
    
    static func fromRecord(_ record: CKRecord) -> ItemListing? {
        guard let name = record.value(forKey: "name") as? String,
              let startDate = record.value(forKey: "startDate") as? Date,
              let endDate = record.value(forKey: "endDate") as? Date,
              let isExpired = record.value(forKey: "isExpired") as? Bool
        else{
            return nil
        }
        
        return ItemListing(id: record.recordID, name: name, startDate: startDate, endDate: endDate, isExpired: isExpired)
    }
    
    
}
