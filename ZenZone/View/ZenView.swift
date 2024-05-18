//
//  ContentView.swift
//  ZenZone
//
//  Created by goat on 22.02.2024.
//

import SwiftUI

extension Color {
    static let softLavender = Color(red: 186.0/255.0, green: 160.0/255.0, blue: 217.0/255.0)
    
    static let cream = Color(red: 249.0/255.0, green: 246.0/255.0, blue: 240.0/255.0)
}

struct ZenView: View {
    @StateObject var meditationViewModel = MeditationViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    
    var body: some View {
        TabView {
            ScrollView {
                VStack {
                    Header(profileViewModel: profileViewModel)
                    Question()
                    BreatheCard()
                    Explore()
                    MeditationList(meditationViewModel: meditationViewModel)
                    Spacer()
                }
                .padding()
                .foregroundColor(.black)

            }
            .background(Color.cream.edgesIgnoringSafeArea(.all))
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            FavoritesView(meditationViewModel: meditationViewModel)
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Favorites")
                    }
            
            ProfileView(profileViewModel: profileViewModel)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}

struct Header: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text("Namaste,")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.softLavender)
                Text("\(profileViewModel.userName)")
                    .font(.title)
            }
            
            Spacer()
            
            Group {
                if let profileImage = profileViewModel.profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                }
            }
        }
    }
}

struct Question: View {
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text("Not sure where to begin?").font(.title).fontWeight(.semibold)
                Text("Let's take a deep breath together")
            }
            Spacer()
        }
        .padding(.vertical)
    }
}

struct BreatheCard: View {
    @State private var isBreathShown = false
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack (alignment: .leading) {
                        Text("Breathing excercise")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    Spacer()
                    Text("5 min")
                        .padding(.all, 6)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                
                HStack (alignment: .bottom) {
                    Image("kkk").resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 250, height: 200)
                    Spacer()
                    Button {
                        isBreathShown = true
                    } label: {
                        Image(systemName: "play.fill")
                            .foregroundColor(.black)
                            .padding()
                            .background(.white)
                            .clipShape(Circle())
                    }

                }
            }
        }
        .fullScreenCover(isPresented: $isBreathShown, content: {
            BreathView(isBreathShown: $isBreathShown)
        })
        .padding()
        .background(Color.softLavender.opacity(0.6))
        .cornerRadius(24)

        
    }
}

struct Explore: View {
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text("Let's enter the Zen Zone").font(.title).fontWeight(.semibold)
            }
            Spacer()
        }
        .padding()
    }
}

struct MeditationList: View {
    @ObservedObject var meditationViewModel: MeditationViewModel
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false){
            HStack(spacing: 24) {
                ForEach(meditationViewModel.meditations) { meditation in
                    MeditationCard(meditationViewModel: meditationViewModel, meditation: meditation)
                }
            }
        }
    }
}

struct MeditationCard: View {
    @ObservedObject var meditationViewModel: MeditationViewModel
    var meditation: MeditationModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Rectangle()
                    .frame(width: 300, height: 220)
                    .foregroundColor(Color.softLavender.opacity(0.5))
                Image(meditation.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
            }
            .onTapGesture {
                meditationViewModel.selectedMeditation = meditation
            }

            
            HStack {
                Text(meditation.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 16)
                
                Spacer()
                
                HStack(spacing: 0) {
                    Button {
                        meditationViewModel.likeMeditation(meditation: meditation)
                    } label: {
                        Image(systemName: meditation.isLiked ? "heart.fill" : "heart")
                            .foregroundColor(meditation.isLiked ? .red : .black)
                            .font(.system(size: 25))
                            .clipShape(Circle())
                    }
                    .padding(.horizontal, 16)
                    .sheet(isPresented: $meditationViewModel.isShowingDescription) {
                        MeditationDescriptionView(meditation: meditationViewModel.selectedMeditation!, meditationViewModel: meditationViewModel, isShowingDescription: $meditationViewModel.isShowingDescription)
                    }
                }
            }

            Text(meditation.description)
                .font(.subheadline)
                .lineLimit(3)
                .padding(.horizontal, 16)
                .padding(.top, 2)
                .foregroundColor(.gray)
            Spacer()
        }
        .frame(width: 300, height: 350)
        .background(Color.white)
        .cornerRadius(30)
    }
}


#Preview {
    ZenView()
        .environmentObject(AudioManager())
}
