//
//  Persistence.swift
//  CoreSwiftData
//
//  Created by Maziar Layeghkar on 28.08.24.
//

import CoreData

//Here basically, we create a container, then load the data from the container and if there is an error in loading, the app will crash.
struct PersistenceController { //This controller holds our Container
    static let shared = PersistenceController() //singleton: one instance that we gonno use in the entire app

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CoreSwiftData") //The name referencing the name of the file that was created in the bundle from scratch by Xcode.
        //Container can be thought of a database which is holding all of our data.
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        //main functionality to load the data from the container
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)") //Automatic crash of our app doing by apple
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
