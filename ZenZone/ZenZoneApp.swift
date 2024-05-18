//
//  ZenZoneApp.swift
//  ZenZone
//
//  Created by goat on 22.02.2024.
//

import SwiftUI

@main
struct ZenZoneApp: App {
    @StateObject var audioManager = AudioManager()
    var body: some Scene {
        WindowGroup {
            ZenView()
                .environmentObject(audioManager)
                .preferredColorScheme(.dark)

        }
    }
}
