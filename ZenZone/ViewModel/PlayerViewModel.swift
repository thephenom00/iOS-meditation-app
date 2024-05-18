//
//  PlayerViewModel.swift
//  ZenZone
//
//  Created by goat on 25.02.2024.
//

import Foundation

final class PlayerViewModel: ObservableObject {
    var selectedMeditation: MeditationModel? {
        didSet {
            isShowingPlayer = true
        }
    }
    
    @Published var isShowingPlayer: Bool = false
}
