//
//  ItemListViewModel.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 23/05/23.
//

import Foundation
import CloudKit

enum RecordType: String {
    case ItemListing = "ItemListing"
    
}

class ItemListViewModel: ObservableObject  {
    private var database: CKDatabase
    private var container: CKContainer
    
    @Published var items: [ItemListing] = []
    
    init(container: CKContainer) {
        self.container = container
        self.database = self.container.publicCloudDatabase
    }
    
    
    func saveItem(name: String, startDate: Date, endDate: Date, isExpired: Bool){
        let record = CKRecord(recordType: RecordType.ItemListing.rawValue)
        let itemListing = ItemListing(name: name, startDate: startDate, endDate: endDate, isExpired: isExpired)
        record.setValuesForKeys(itemListing.toDictionary())
        
//        save record to database
        self.database.save(record) { newRecord, error in
            if let error = error {
                print(error)
            } else {
                if let _ = newRecord {
                    print("Saved!")
                }
            }
            
        }
    }
    
//     func fetchDataFromCloudKit() {
//            let container = CKContainer.default()
//            let publicDatabase = container.publicCloudDatabase
//            let recordType = RecordType.ItemListing.rawValue// Replace with your CloudKit record type
//            
//            let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
//            
//            publicDatabase.perform(query, inZoneWith: nil) { (results, error) in
//                if let error = error {
//                    print("Error fetching data from CloudKit: \(error.localizedDescription)")
//                } else if let records = results {
//                    let fetchedRecords = records.map { record in
//                                        ItemListing(
//                                            id: record.recordID,
//                                            name: record["name"] as? String ?? "",
//                                            startDate: record["startDate"] as? Date ?? Date(),
//                                            endDate: record["endDate"] as? Date ?? Date(),
//                                            isExpired: record["isExpired"] as? Bool ?? true
//                                        )
//                                    }
//                    print(fetchedRecords.count)
//                                    DispatchQueue.main.async {
//                                        self.items = fetchedRecords
//                                    }
//                                }
//            }
//        }
    
    
}

struct ItemViewModel {
    let itemListing: ItemListing
    
    var recordId: CKRecord.ID? {
        itemListing.id
    }
    var name: String {
        itemListing.name
    }
    var startDate: Date {
        itemListing.startDate
    }
    var endDate: Date {
        itemListing.endDate
    }
    var isExpired: Bool {
        itemListing.isExpired
    }
}
