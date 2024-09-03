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
            CoreDataFetch() //All the views and subviews will have access viewContext
                .environment(\.managedObjectContext, persistenceController.container.viewContext) //viewContext is the data inside of the container
        }
    }
}
