import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color(.init(red: 242/255, green: 242/255, blue: 242/255))
                .edgesIgnoringSafeArea(.all)

            VStack {
                
                Spacer()
                
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 137, height: 137)
                    

                Text("Your All-In-One\nFitness Companion")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Spacer()

                Image("bottom-image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
