import SwiftUI
import AVKit

@main
struct Tiger_CatcherApp: App {
    init() {
        // Загрузка громкости из UserDefaults
        let volume = UserDefaults.standard.object(forKey: "volume") != nil ? UserDefaults.standard.double(forKey: "volume") : 0.5
        SoundManager.shared.setVolume(volume)
    }
    
    var body: some Scene {
        WindowGroup {
            MenuView()
                .onAppear {
                    SoundManager.shared.playSound()
                }
        }
    }
}
