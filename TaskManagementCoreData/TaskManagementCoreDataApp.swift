//
//  TaskManagementCoreDataApp.swift
//  TaskManagementCoreData
//
//  Created by MINH DUC NGUYEN on 19/06/2022.
//

import SwiftUI

@main
struct TaskManagementCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
