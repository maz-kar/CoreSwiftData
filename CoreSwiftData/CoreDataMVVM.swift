//
//  CoreData.swift
//  CoreSwiftData
//
//  Created by Maziar Layeghkar on 03.09.24.
//

import SwiftUI
import CoreData

class CoreDataMVVMViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var savedEntities: [VegetableEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "VegetableContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error while loading. \(error)")
            }
        }
        
        fetchRequest()
    }
    
    func fetchRequest() {
        let request = NSFetchRequest<VegetableEntity>(entityName: "VegetableEntity")
        
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error while fetching. \(error)")
        }
    }
    
    func addItem(text: String) {
        let newItem = VegetableEntity(context: container.viewContext)
        newItem.name = text
        
        saveItem()
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let deletingItem = savedEntities[index]
        container.viewContext.delete(deletingItem)
        
        saveItem()
    }
    
    func updateItem(tappedItem: VegetableEntity) {
        let currentItem = tappedItem.name ?? ""
        let newItem = currentItem + "!"
        tappedItem.name = newItem
        
        saveItem()
    }
    
    func saveItem() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error while saving. \(error)")
        }
        fetchRequest()
    }
    
}

struct CoreDataMVVM: View {
    @StateObject var vm = CoreDataMVVMViewModel()
    @State var textFieldText: String = ""
    let backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                TextField("Add vegetables here...", text: $textFieldText)
                    .font(.headline)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color(backgroundColor))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Button(action: {
                    guard !textFieldText.isEmpty else { return }
                    vm.addItem(text: textFieldText)
                    textFieldText = ""
                }, label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundStyle(Color.white)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                })
            }
            .padding()
            
            List {
                ForEach(vm.savedEntities) { entity in
                    VStack {
                        Text(entity.name ?? "No Name")
                            .onTapGesture {
                                vm.updateItem(tappedItem: entity)
                            }
                    }
                }
                .onDelete(perform: vm.deleteItem)
            }
            .listStyle(.plain)
            .navigationTitle("Vegetables")
        }
    }
}

#Preview {
    CoreDataMVVM()
}
