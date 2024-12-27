//
//  Item.swift
//  Check List
//
//  Created by Ben Heath on 12/23/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var item: String
    var checked: Bool
    
    init(item: String) {
        self.item = item
        self.checked = false
    }
}
