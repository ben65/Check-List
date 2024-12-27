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
        
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    if (!item.checked) {
                        Label(item.item, systemImage: "bird")
                            .onTapGesture {
                                print ("Check \(item.item)")
                                item.checked = true
                            }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            Text("Checked Items")
            List {
                ForEach(items) { item in
                    if (item.checked) {
                        Label(item.item, systemImage: "flag.pattern.checkered")
                            .strikethrough(true)
                            .onTapGesture {
                                print ("Uncheck /(item.item)")
                                item.checked = false
                            }
                    }
                }
                .onDelete(perform: deleteItems)
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
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
