//
//  CoreSwiftDataApp.swift
//  CoreSwiftData
//
//  Created by Maziar Layeghkar on 28.08.24.
//

import SwiftUI

@main
struct CoreSwiftDataApp: App {
    let persistenceController = PersistenceController.shared //singleton class

    var body: some Scene {
        WindowGroup {
            ContentView() //All the views and subviews will have access viewContext
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
