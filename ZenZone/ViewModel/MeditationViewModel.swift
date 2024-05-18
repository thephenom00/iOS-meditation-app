//
//  ZenViewModel.swift
//  ZenZone
//
//  Created by goat on 25.02.2024.
//

import SwiftUI

final class MeditationViewModel: ObservableObject {
    @Published var meditations: [MeditationModel] = []
    @Published var isShowingDescription: Bool = false
    
    private let key = "meditationsKey"
    
    var selectedMeditation: MeditationModel? {
        didSet {
            isShowingDescription = true
        }
    }
    
    init() {
        if meditations.isEmpty {
            loadDefaultMeditations()
        }
        loadMeditations()
    }
    
    func loadDefaultMeditations() {
        meditations = [
            MeditationModel(name: "Starry Night", description: "Immerse yourself in the tranquility of Vincent van Gogh's iconic masterpiece with this serene meditation track. Inspired by van Gogh's mesmerizing depiction of the night sky, this meditation invites you to experience a moment of profound stillness and reflection", image: "starry", track: "starry_night", duration: 180),
            MeditationModel(name: "Rainy Forest", description: "Immerse yourself in the tranquil ambiance of a Rainy Forest, where gentle raindrops harmonize with the soothing whispers of rustling leaves, offering a serene journey into nature's embrace.", image: "tee", track: "rainy_forest", duration: 183),
            MeditationModel(name: "Tropical Breeze", description: "Transport yourself to a serene paradise of a Tropical Breeze. Let the gentle rustle of palm leaves and the soothing rhythm of ocean waves lull you into a state of deep relaxation and inner peace.", image: "palm", track: "tropical_breeze", duration: 101),
            MeditationModel(name: "Thunderous Calm", description: "Immerse yourself in the calming embrace of a Thunderstorm Tranquility. Explore the power of nature's symphony as you find solace amidst the storm's embrace.", image: "thunder", track: "thunderous_calm", duration: 183),
            MeditationModel(name: "Fire Serenity", description: "Let the warmth of the flames and the soft whispers of the night envelop you, guiding you into a state of deep relaxation and inner peace amidst the tranquil wilderness.", image: "fire", track: "fire_serenity", duration: 140)
        ]
    }
    
    func likeMeditation(meditation: MeditationModel) {
        if let index = meditations.firstIndex(where: { $0.name == meditation.name }) {
            meditations[index] = meditations[index].like()
            saveMeditations()
        }
    }

    func saveMeditations() {
        let encoder = JSONEncoder()
        do {
            let encodedMeditations = try encoder.encode(meditations)
            UserDefaults.standard.set(encodedMeditations, forKey: key)
        } catch {
            print("Error while encoding meditations: \(error.localizedDescription)")
        }
    }
    
    func loadMeditations() {
        if let savedMeditations = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            do {
                let loadedMeditations = try decoder.decode([MeditationModel].self, from: savedMeditations)
                meditations = loadedMeditations
            } catch {
                print("Error while decoding meditations: \(error.localizedDescription)")
            }
        }
    }
    
    func formatTime(timeInterval: TimeInterval) -> String {
        let totalSeconds = Int(timeInterval)
        let minutes = totalSeconds / 60
        let remainingSeconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    static let sample = MeditationModel(name: "Starry Night", description: "Immerse yourself in the tranquility of Vincent van Gogh's iconic masterpiece with this serene meditation track. Inspired by van Gogh's mesmerizing depiction of the night sky, this meditation invites you to experience a moment of profound stillness and reflection", image: "starry", track: "starry_night", duration: 180)
}
