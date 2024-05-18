//
//  BreathView.swift
//  ZenZone
//
//  Created by goat on 13.05.2024.
//

import SwiftUI

struct BreathView: View {
    @State var currentType: BreatheType = sampleTypes[0]
    @Namespace var animation
    @State var showBreatheView: Bool = false
    @State var startAnimation: Bool = false
    @State var timerCount: CGFloat = 0
    @State var breatheAction: String = "Breathe In"
    @State var count: Int = 0
    @Binding var isBreathShown: Bool
    var body: some View {
        ZStack {
            Background()
            Content()
            
            Text(breatheAction)
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 50)
                .opacity(showBreatheView ? 1 : 0)
                .animation(.easeInOut(duration: 1), value: breatheAction)
                .animation(.easeInOut(duration: 1), value: showBreatheView)

        }
        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
            if showBreatheView {
                if timerCount >= 3.2 {
                    timerCount = 0
                    breatheAction = (breatheAction == "Breathe Out" ? "Breathe In" : "Breathe Out")
                    withAnimation(.easeInOut(duration: 3).delay(0.1)) {
                        startAnimation.toggle()
                    }
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                } else {
                    timerCount += 0.01
                }
                count = 3 - Int(timerCount)
            } else {
                timerCount = 0
            }
        }


    }
    
    @ViewBuilder
    func Content() -> some View {
        VStack {
            HStack {
                Button {
                    isBreathShown = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(.leading)
            .opacity(showBreatheView ? 0 : 1)
            
            
            GeometryReader {proxy in
                let size = proxy.size
                
                VStack {
                    CircleView(size: size)
                    
                    Text("What do you feel right now?")
                        .font(.title3)
                        .foregroundColor(.white)
                        .opacity(showBreatheView ? 0 : 1)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(sampleTypes) { type in
                                Text(type.title)
                                    .foregroundColor(currentType.id == type.id ? .black : .white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 15)
                                    .background {
                                        ZStack {
                                            if currentType.id == type.id {
                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                    .fill(.white)
                                                    .matchedGeometryEffect(id: "TAB", in: animation)
                                            } else {
                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                    .stroke(.white.opacity(0.5))
                                            }
                                        }
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(.easeInOut) {
                                            currentType = type
                                        }
                                    }
                            }
                        }
                        .padding()
                        .padding(.leading, 15)
                    }
                    .frame(width: 400)
                    .opacity(showBreatheView ? 0 : 1)

                    
                    Button {
                        startBreathing()
                    } label: {
                        Text(showBreatheView ? "FINISH" : "START")
                            .fontWeight(.semibold)
                            .foregroundColor(showBreatheView ? .white.opacity(0.75) : .black)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background {
                                if (showBreatheView) {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(.white.opacity(0.5))
                                } else {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(currentType.color.gradient)
                                }
        
                            }
                    }
                    .padding()

                }
                .frame(width: size.width, height: size.height)
                
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    func startBreathing() {
        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
            showBreatheView.toggle()
            
            if showBreatheView {
                withAnimation(.easeInOut(duration: 3).delay(0.05)) {
                    startAnimation = true
                }
            } else {
                withAnimation(.easeInOut(duration: 1.5)) {
                    startAnimation = false
                }
            }

        }
    }
    
    @ViewBuilder
    func CircleView(size: CGSize) -> some View {
        ZStack {
            ForEach(1...8, id: \.self) { index in
                Circle()
                    .fill(currentType.color.gradient.opacity(0.5))
                    .frame(width: 150, height: 150)
                    .offset(x: startAnimation ? 0 : 75)
                    .rotationEffect(.init(degrees: Double(index) * 45))
                    .rotationEffect(.init(degrees: startAnimation ? -45 : 0 ))
            }
        }
        .scaleEffect(startAnimation ? 0.8 : 1)
        .overlay(content: {
            Text("\(count == 0 ? 1 : count)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .animation(.easeInOut, value: count)
                .opacity(showBreatheView ? 1 : 0)
        })
        .frame(height: (size.width + 50))
    }

    @ViewBuilder
    func Background() -> some View {
        GeometryReader {proxy in
            let size = proxy.size
            Image("mountains")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()
                .blur(radius: startAnimation ? 4 : 0, opaque: true)
                .overlay {
                   ZStack {
                       ZStack {
                           Rectangle()
                               .fill(LinearGradient(colors: [
                                   currentType.color.opacity(0.9),
                                   .clear,
                                   .clear
                               ], startPoint: .top, endPoint: .bottom))
                               .frame(height: size.height / 1.5)
                               .frame(maxHeight: .infinity, alignment: .top)
                       }

                       Rectangle()
                           .fill(LinearGradient(colors: [
                               .clear,
                               .black,
                               .black,
                               .black,
                               .black
                           ], startPoint: .top, endPoint: .bottom))
                           .frame(height: size.height / 1.35)
                           .frame(maxHeight: .infinity, alignment: .bottom)

                   }
                }
        }
        .ignoresSafeArea()
    }
}


#Preview {
    BreathView(isBreathShown: .constant(true))
}
