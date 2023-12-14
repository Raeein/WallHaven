import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    var animationName: String
    var loopMode: LottieLoopMode = .loop

    
    func makeUIView(context: Context) -> LottieAnimationView {
           let view = LottieAnimationView(name: animationName, bundle: Bundle.main)
           view.loopMode = loopMode
           view.play()
           
           return view
           
       }

    func updateUIView(_ uiView: UIViewType, context: Context) {
          
      }
}
