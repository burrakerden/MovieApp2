//
//  SplashController.swift
//  MovieApp2
//
//  Created by Burak Erden on 17.02.2023.
//

import UIKit

class SplashController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkConnection()
        navigationController?.isNavigationBarHidden = true
    }

    //MARK: - Check Network Connection
    
    func checkConnection() {
        if NetworkMonitor.shared.isConnected {
            print("connected")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                print("3 seconds")
                let vc = MovieController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            print("not")
            alert()
        }
    }
    
    
    //MARK: - UIAlert
    
    func alert() {
        let ac = UIAlertController(title: "WARNING", message: "Check your internet connection", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
//            self.checkConnection()
//        }))
        present(ac, animated: true)
    }

}
