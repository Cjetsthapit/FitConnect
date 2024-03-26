import SwiftUI

struct SplashScreen: View {
    @State private var logoOpacity = 0.0
    @State private var textOpacity = 0.0
    
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 137, height: 137)
                    .opacity(logoOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.2)) {
                            logoOpacity = 1.0
                        }
                    }
                
                Text("Your All-In-One\nFitness Companion")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .opacity(textOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.2).delay(0.5)) {
                            textOpacity = 1.0
                        }
                    }
                
                Spacer()
            }
            
            VStack {
                Spacer()
                Image("bottom-image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}

