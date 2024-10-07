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
        for x in 0..<10 {
            let newItem = FruitEntity(context: viewContext)
            newItem.name = "Apple \(x)"
        }
        do {
            try viewContext.save()
        } catch {
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
                fatalError("Unresolved error \(error), \(error.userInfo)") //Automatic crash of our app doing by apple
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
