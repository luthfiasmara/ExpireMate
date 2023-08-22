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

//if [[ "$(uname -m)" == arm64 ]]; then
//    export PATH="/opt/homebrew/bin:$PATH"
//fi
//
//if which swiftlint > /dev/null; then
//  swiftlint
//else
//  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
//fi
