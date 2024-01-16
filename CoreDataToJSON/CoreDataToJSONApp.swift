//
//  CoreDataToJSONApp.swift
//  CoreDataToJSON
//
//  Created by paku on 2024/01/14.
//

import SwiftUI

@main
struct CoreDataToJSONApp: App {
    let persistenceController = PersistanceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
