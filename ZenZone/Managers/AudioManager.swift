import Foundation
import AVKit

final class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published private(set) var isPlaying: Bool = false
    @Published private(set) var isLooping: Bool = false
    var player: AVAudioPlayer?
    
    func startPlayer(track: String, isPreview: Bool = false) {
        guard let url = Bundle.main.url(forResource: track, withExtension: "mp3") else {
            print("Resource not found.")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            
            player?.delegate = self
            
            if (isPreview) {
                player?.prepareToPlay()
            } else {
                player?.play()
                isPlaying = true
            }
            
        } catch {
            print("Fail to initialize AudioPlayer", error)
        }
    }
    
    func pause() {
        guard let player = player else {
            return
        }
        
        if player.isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }
    
    func stop() {
        guard let player = player else {
            return
        }
        
        if player.isPlaying {
            player.stop()
            isPlaying = false
        }
    }
    
    func loop() {
        guard let player = player else {
            return
        }
        
        player.numberOfLoops = player.numberOfLoops == 0 ? -1 : 0
        isLooping = player.numberOfLoops != 0
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        
    }
}
