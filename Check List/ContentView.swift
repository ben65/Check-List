//
//  ContentView.swift
//  Check List
//
//  Created by Ben Heath on 12/23/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    @State private var newItem = ""
    
    enum FocusField: Hashable {
      case field
    }
    
    let uncheckedFilter = {(item:Item) -> Bool in !item.checked}
    let checkedFilter = {(item:Item) -> Bool in item.checked}
        
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        NavigationSplitView {
            
            List {
                Section(header: Text("List Items")) {
                    ForEach(filteredItems(filter: uncheckedFilter)) { item in
                        Label(item.item, systemImage: "bird")
                            .onTapGesture {
                                item.checked = true
                            }
                    }
                    .onDelete(perform: deleteItems)
                }
                Section(header: Text("Checked Items")) {
                    ForEach(filteredItems(filter: checkedFilter)) { item in
                        Label(item.item, systemImage: "flag.pattern.checkered")
                            .strikethrough(true)
                            .onTapGesture {
                                item.checked = false
                            }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    TextField("New Item", text: $newItem)
                        .focused($focusedField, equals: .field)
                                  .onAppear {
                                    self.focusedField = .field
                                  }
                                  .onSubmit {
                                      self.focusedField = .field
                                  }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .onSubmit(addItem)
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            modelContext.insert(Item(item: newItem))
            newItem = ""
            
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    private func filteredItems(filter: (Item) -> Bool) -> [Item] {
        var filteredItems: [Item] = []
        for item in items {
            if (filter(item)) {
                filteredItems.append(item)
            }
        }
        return filteredItems
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
