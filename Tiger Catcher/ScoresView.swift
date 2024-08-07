import SwiftUI

struct ScoresView: View {
    
    var highScores: [HighScore] {
        return UserDefaults.standard.highScores
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Image("ScoresBackground")
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    VStack(spacing: 100) {
                        Spacer()
                        ZStack {
                            Image("ScoresBox")
                                .resizable()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.4)
                                .overlay(
                                    VStack(spacing: 30) {
                                        ForEach(0..<3) { index in
                                            HStack {
                                                Spacer()
                                                if highScores.indices.contains(index) {
                                                    Text("\(highScores[index].score)")
                                                        .font(.custom("Helvetica Neue", size: geometry.size.height / 18))
                                                        .foregroundColor(.black)
                                                } else {
                                                    Text("...")
                                                        .font(.custom("Helvetica Neue", size: geometry.size.height / 18))
                                                        .foregroundColor(.black)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.bottom, 20)
                                    .padding(.trailing, 30)
                                )
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
    }
}

#Preview {
    ScoresView()
}
