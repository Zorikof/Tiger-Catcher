import SwiftUI

struct OptionsView: View {
    @State private var volume: Double = {
        let volume = UserDefaults.standard.object(forKey: "volume") != nil ? UserDefaults.standard.double(forKey: "volume") : 0.5
        return volume
    }()
    
    @State private var sound: Double = {
        let sound = UserDefaults.standard.object(forKey: "sound") != nil ? UserDefaults.standard.double(forKey: "sound") : 0.5
        return sound
    }()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Image("OptionsBackground")
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    VStack(spacing: 100) {
                        Spacer()
                        ZStack {
                            Image("OptionsBox")
                                .resizable()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.4)
                            VStack(spacing: 20) {
                                CustomSliderView(value: $volume, iconName: "MusicLabel", geometry: geometry)
                                CustomSliderView(value: $sound, iconName: "SoundLabel", geometry: geometry)
                            }
                        }
                        NavigationLink(destination: MenuView()) {
                            Image("BackButton")
                                .resizable()
                                .frame(width: geometry.size.width * 0.6, height: geometry.size.height / 7)
                        }
                        
                        .simultaneousGesture(TapGesture().onEnded {
                            ButtonSoundManager.shared.playTapSound()
                        })
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onDisappear {
            UserDefaults.standard.set(volume, forKey: "volume")
            UserDefaults.standard.set(sound, forKey: "sound")
            SoundManager.shared.setVolume(volume)
            print("Saved volume: \(volume)")
            print("Saved sound: \(sound)")
        }
        .onAppear {
            print("Loaded volume: \(volume)")
            print("Loaded sound: \(sound)")
        }
    }
}

struct CustomSliderView: View {
    @Binding var value: Double
    var iconName: String
    var geometry: GeometryProxy
    
    var body: some View {
        HStack {
            Image(iconName)
                .resizable()
                .frame(width: geometry.size.width / 5, height: geometry.size.width / 5)
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: geometry.size.width * 0.35, height: geometry.size.height / 20)
                    .foregroundColor(Color.black.opacity(0.3))
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: CGFloat(value) * geometry.size.width * 0.35, height: geometry.size.height / 20)
                    .foregroundColor(Color(red: 0, green: 0.5, blue: 0, opacity: 1))
                
                Image("DragCircle")
                    .resizable()
                    .frame(width: geometry.size.height / 20, height: geometry.size.height / 20)
                    .offset(x: CGFloat(value) * geometry.size.width * 00.35 - geometry.size.height / 40)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                let newValue = min(max(0, gesture.location.x / (geometry.size.width * 0.35)), 1)
                                value = Double(newValue)
                                UserDefaults.standard.set(value, forKey: iconName == "SoundLabel" ? "sound" : "volume")
                                print("\(iconName) updated to: \(value)")
                                if iconName == "SoundLabel" {
                                    ButtonSoundManager.shared.audioPlayer?.volume = Float(value)
                                    print("Button sound volume updated to: \(value)")
                                } else {
                                    SoundManager.shared.player?.volume = Float(value)
                                    print("Sound volume updated to: \(value)")
                                }
                            }
                    )
            }
            .frame(width: geometry.size.width * 0.4)
        }
    }
}

#Preview {
    OptionsView()
}
