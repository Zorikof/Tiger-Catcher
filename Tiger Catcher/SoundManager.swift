import Foundation
import AVKit

class SoundManager {
    static let shared = SoundManager()
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Sound", withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            let volume = UserDefaults.standard.object(forKey: "volume") != nil ? UserDefaults.standard.double(forKey: "volume") : 0.5
            player?.volume = Float(volume)
            player?.numberOfLoops = -1
            player?.play()
        } catch {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
    
    func setVolume(_ volume: Double) {
        player?.volume = Float(volume)
    }
    
    func stopSound() {
        player?.stop()
    }
}

class ButtonSoundManager {
    static let shared = ButtonSoundManager()
    var audioPlayer: AVAudioPlayer?

    func playTapSound() {
        guard let url = Bundle.main.url(forResource: "Tap", withExtension: "mp3") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            let soundVolume = UserDefaults.standard.object(forKey: "sound") != nil ? UserDefaults.standard.double(forKey: "sound") : 0.5
            audioPlayer?.volume = Float(soundVolume)
            audioPlayer?.play()
        } catch {
            print("Failed to initialize AVAudioPlayer: \(error.localizedDescription)")
        }
    }
}
