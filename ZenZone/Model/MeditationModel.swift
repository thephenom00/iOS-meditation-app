//
//  Meditation.swift
//  ZenZone
//
//  Created by goat on 24.02.2024.
//

import Foundation

struct MeditationModel: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let image: String
    let track: String
    let duration: TimeInterval
    var isLiked: Bool

    init(id: UUID = UUID(), name: String, description: String, image: String, track: String, duration: TimeInterval, isLiked: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
        self.track = track
        self.duration = duration
        self.isLiked = isLiked
    }
    
    func like() -> MeditationModel {
        return MeditationModel(id: id, name: name, description: description, image: image, track: track, duration: duration, isLiked: !isLiked)
    }
}



