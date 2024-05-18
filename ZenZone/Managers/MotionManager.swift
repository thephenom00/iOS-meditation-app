//
//  MotionManager.swift
//  ZenZone
//
//  Created by goat on 17.05.2024.
//

import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    @Published var showPopUp = false
    private let motionManager = CMMotionManager()
    private var initialX: Double?
    private var initialY: Double?
    private var x = 0.0
    private var y = 0.0
    private let movementThreshold: Double = 0.5
    
    init() {
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] data, error in
            guard let self = self, let motion = data else { return }
            
            self.x = motion.attitude.roll
            self.y = motion.attitude.pitch
            
            if self.initialX == nil || self.initialY == nil {
                self.initialX = self.x
                self.initialY = self.y
            }
            
            guard let initialX = self.initialX, let initialY = self.initialY else { return }
            
            let deltaX = abs(self.x - initialX)
            let deltaY = abs(self.y - initialY)
            
            if deltaX > self.movementThreshold || deltaY > self.movementThreshold {
                showPopUp = true
                self.initialX = self.x
                self.initialY = self.y
            }

        }
    }
}
