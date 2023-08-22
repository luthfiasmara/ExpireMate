//
//  CoreDataManager.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 22/08/23.
//

import Foundation

class CoreDataManager{
    static let shared = CoreDataManager()
    let viewContext = PersistenceController.shared.viewContext
    func saveContext(){
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}
