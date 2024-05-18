//
//  MeditationView.swift
//  ZenZone
//
//  Created by goat on 24.02.2024.
//

import SwiftUI

struct MeditationDescriptionView: View {
    var meditation: MeditationModel
    @StateObject var playerViewModel = PlayerViewModel()
    @ObservedObject var meditationViewModel: MeditationViewModel
    @Binding var isShowingDescription: Bool
    
    var body: some View {
        VStack (spacing: 0) {
            Image(meditation.image)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
                .background(Color.softLavender.opacity(0.7))
            
            ZStack {
                Color(Color.white)
                
                VStack (alignment: .leading, spacing: 20) {
                    VStack (alignment: .leading) {
                        Text("MUSIC")
                        Text(meditationViewModel.formatTime(timeInterval: meditation.duration))
                    }
                    .font(.subheadline)
                    .textCase(.uppercase)
                    .opacity(0.7)
                    
                    Text(meditation.name)
                        .font(.title)
                    Text(meditation.description)
                    
                    VStack {
                        Button() {
                            playerViewModel.selectedMeditation = meditation
                        } label: {
                            Label("Play", systemImage: "play.fill")
                                .font(.headline)
                                .padding(.vertical, 20)
                                .frame(maxWidth: .infinity)
                                .background(Color.softLavender.opacity(0.8))
                                .foregroundColor(.black)
                                .clipShape(Capsule())
                                .padding()
                        }
                        .fullScreenCover(isPresented: $playerViewModel.isShowingPlayer) {
                            PlayerView(meditationViewModel: meditationViewModel, meditation: meditation, isShowingPlayer: $playerViewModel.isShowingPlayer)
                        }
                        
                    }
                    
                    Spacer()
                    
                }
                .padding()
                .foregroundColor(.black)
                
                
            }
            
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MeditationDescriptionView(meditation: MeditationViewModel.sample, meditationViewModel: MeditationViewModel(), isShowingDescription: .constant(true))
        .environmentObject(AudioManager())
}
