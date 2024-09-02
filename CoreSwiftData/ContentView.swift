//
//  ContentView.swift
//  CoreSwiftData
//
//  Created by Maziar Layeghkar on 28.08.24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    //    @FetchRequest( //This sortes all the data in this request here by timestamp
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    //        animation: .default)
    //    private var items: FetchedResults<Item> //items var is @FetchRequest. items is of type FetchResults and it going to be bunch of Item.
    
    @FetchRequest(
        entity: FruitEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FruitEntity.name, ascending: true)])
    private var fruits: FetchedResults<FruitEntity>
    
    @State var textFieldText: String = ""
    
    var body: some View {
        let backgroundColorOfTextField = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) //to use colorLiteral: #colorLiteral(...
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Add text here...", text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color(backgroundColorOfTextField))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                
                Button(action: {
                    addItem()
                    textFieldText = ""
                }, label: {
                    Text("Submit")
                        .font(.headline)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                })
                .padding(.horizontal)
                
                List {
                    ForEach(fruits) { fruit in //Our first data is a List of items
                        Text("\(fruit.name ?? "")")
                            .onTapGesture {
                                updateItem(tappedItem: fruit)
                            }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(.plain)
            }
            .padding()

            .navigationTitle("Fruits")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
            }
        }
    }
    
    /*
     For Adding: We need to create an entity. It will be a blank entity, so we need to update all the variables with the data and finally Save.
     For Updating: We need to get the entity. Update whatever variables we want. Then Save.
     FOr Deleting: We need to find the entity. Delete it from the context Then Save.
     */
    private func addItem() {
        withAnimation {
            let newFruit = FruitEntity(context: viewContext)
            //let newItem = Item(context: viewContext)//we put this viewContext in the environment at the beginning.
            newFruit.name = textFieldText
            saveItems()
            textFieldText = ""
        }
    }
    
    private func updateItem(tappedItem: FruitEntity) {
        let currentName = tappedItem.name ?? ""
        let newName = currentName + "!"
        tappedItem.name = newName
        
        saveItems()
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            //Effective approach of finding the correct item and then delete it
            //offsets.map { fruits[$0] }.forEach(viewContext.delete)
            
            //Easier approach for finding and deleting the item
            guard let index = offsets.first else { return }
            let fruitEntity = fruits[index]
            viewContext.delete(fruitEntity)
            
            saveItems()
        }
    }
    
    private func saveItems() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
