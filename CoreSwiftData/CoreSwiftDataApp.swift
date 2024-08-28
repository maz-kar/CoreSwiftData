//
//  CoreSwiftDataApp.swift
//  CoreSwiftData
//
//  Created by Maziar Layeghkar on 28.08.24.
//

import SwiftUI

@main
struct CoreSwiftDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
