//
//  BreatheType.swift
//  ZenZone
//
//  Created by goat on 13.05.2024.
//

import SwiftUI

struct BreatheType: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String
    var color: Color
}

let sampleTypes: [BreatheType] = [
    .init(title: "Zen Zone", color: .softLavender),
    .init(title: "Anger", color: .red),
    .init(title: "Joy", color: .orange),
    .init(title: "Happiness", color: .yellow),
    .init(title: "Growth", color: .green),
    .init(title: "Loyalty", color: .blue),
    .init(title: "Creativity", color: .purple)
    
]


