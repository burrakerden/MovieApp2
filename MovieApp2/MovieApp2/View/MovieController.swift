//
//  MovieController.swift
//  MovieApp2
//
//  Created by Burak Erden on 16.02.2023.
//

import UIKit
import Lottie
import FirebaseAnalytics

class MovieController: UIViewController {
    
    private var animationView: LottieAnimationView!
    @IBOutlet weak var viewForAnimation: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimation()
    }
    
    
    func setupAnimation() {
        animationView = .init(name: "loading")
        animationView.frame = viewForAnimation.frame
        animationView.loopMode = .loop
        viewForAnimation.addSubview(animationView)
        animationView.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.animationView.stop()
            self.viewForAnimation.isHidden = true
            Analytics.logEvent("press_button", parameters: nil)
        }
    }
    


    
    
}
