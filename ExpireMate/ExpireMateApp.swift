//
//  ExpireMateApp.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 25/04/23.
//

import SwiftUI
//import CloudKit

@main
struct ExpireMateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var dataController = DataController()
    
    
    var body: some Scene {
        WindowGroup{
            HomeView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}