import SwiftUI

struct MenuView: View {
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Image("MenuBackground")
                        .resizable()
                        .ignoresSafeArea()
                        .scaleEffect(CGSize(width: 1, height: 1))
                    VStack {
                        NavigationLink(destination: GameView()) {
                            Image("PlayButton")
                                .resizable()
                                .frame(width: geometry.size.width / 1.5, height: geometry.size.height / 8)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 1.5)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            ButtonSoundManager.shared.playTapSound()
                        })
                        HStack {
                            NavigationLink(destination: OptionsView()) {
                                Image("OptionsButton")
                                    .resizable()
                                    .frame(width: geometry.size.width / 4, height: geometry.size.height / 5)
                                    
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                ButtonSoundManager.shared.playTapSound()
                            })
                            NavigationLink(destination: ScoresView()) {
                                Image("ScoresButton")
                                    .resizable()
                                    .frame(width: geometry.size.width / 4, height: geometry.size.height / 5)
                                    
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                ButtonSoundManager.shared.playTapSound()
                            })
                        }
                        .padding(.bottom, 16)
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    MenuView()
}
