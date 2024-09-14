//
//  Item.swift
//  FlashKick
//
//  Created by Nick Lavrov on 13/09/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
