//
//  PlayerView.swift
//  ZenZone
//
//  Created by goat on 24.02.2024.
//

import SwiftUI

struct PlayerView: View {
    @StateObject var motionManager = MotionManager()
    @ObservedObject var meditationViewModel : MeditationViewModel
    @EnvironmentObject var audioManager: AudioManager
    @Environment(\.presentationMode) var presentationMode
    @State private var value: Double = 0.0
    @State private var isDragging: Bool = false
    
    @State private var showAlert: Bool = false

    var turnMusicOff: Bool = false
    var meditation: MeditationModel
    @Binding var isShowingPlayer: Bool
    
    let timer = Timer
        .publish(every: 0.1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .foregroundColor(Color.softLavender.opacity(0.9))
                .ignoresSafeArea()
            
            Image(meditation.image)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                .padding(.bottom, 180)
        
            
            VStack (spacing: 32) {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        audioManager.stop()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                    }
                    .padding(.top)
                    Spacer()
                }
                
                Spacer()
                
                VStack (spacing: 5) {
                    Text(meditation.name)
                        .font(.system(size: 33))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                    
                    if let player = audioManager.player {
                        Slider(value: $value, in: 0...player.duration) {
                            editing in
                            
                            isDragging = editing
                            
                            if !editing {
                                player.currentTime = value
                            }
                        }
                            .accentColor(.white)
                        
                        HStack {
                            Text(meditationViewModel.formatTime(timeInterval: player.currentTime))
                            Spacer()
                            Text(meditationViewModel.formatTime(timeInterval: meditation.duration - player.currentTime))
                        }
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                        
                        HStack {
                            
                            PlayerControllerButton(systemName: "repeat", fontSize: 30, color: audioManager.isLooping ? .teal : .white, action: {
                                audioManager.loop()
                            })
                            Spacer()
                            
                            PlayerControllerButton(systemName: "gobackward.10", fontSize: 30, action: {
                                player.currentTime -= 10
                            })
                            Spacer()

                            
                            PlayerControllerButton(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill", fontSize: 65, action: {
                                audioManager.pause()
                            })
                            Spacer()

                            PlayerControllerButton(systemName: "goforward.10", fontSize: 30, action: {
                                player.currentTime += 10
                            })
                            Spacer()
                            
                            PlayerControllerButton(systemName: "stop.circle.fill", fontSize: 30, action: {
                                audioManager.stop()
                                presentationMode.wrappedValue.dismiss()
                            })
                            
                        }
                    }
                    
                }
                .padding(.bottom, 85)
            }
            .padding(25)
            .onAppear() {
                   audioManager.startPlayer(track: meditation.track, isPreview: turnMusicOff)
            }
            .onChange(of: motionManager.showPopUp) {
                if motionManager.showPopUp {
                    if audioManager.isPlaying {
                        showAlert = true
                        audioManager.pause()
                    } else {
                        motionManager.showPopUp = false
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Mindful Moment"),
                    message: Text("We noticed some movement. To fully benefit from your meditation, please remain still."),
                    dismissButton: .default(Text("Got it")) {
                        showAlert = false
                        motionManager.showPopUp = false
                    }
                )
            }
            .onReceive(timer, perform: { _ in
                guard let player = audioManager.player, !isDragging else {
                    return
                }
                value = player.currentTime
            })
        }
    }
}

#Preview {
    PlayerView(meditationViewModel: MeditationViewModel(), meditation: MeditationViewModel.sample, isShowingPlayer: .constant(true))
        .environmentObject(AudioManager())
}
