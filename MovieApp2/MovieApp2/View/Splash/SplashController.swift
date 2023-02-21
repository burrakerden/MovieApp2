//
//  SplashController.swift
//  MovieApp2
//
//  Created by Burak Erden on 17.02.2023.
//

import UIKit
import Firebase


class SplashController: UIViewController {

    @IBOutlet weak var remoteText: UILabel!
    var middleText = "Loodos"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkConnection()
        remoteText.text = middleText
    }

    //MARK: - Check Network Connection
    
    func checkConnection() {
        if NetworkMonitor.shared.isConnected {
            print("connected")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                let vc = MovieController()
                self.navigationController?.isNavigationBarHidden = true
                self.navigationController?.pushViewController(vc, animated: false)
            }
        } else {
            alert()
        }
    }
    
    
    //MARK: - UIAlert
    
    func alert() {
        let ac = UIAlertController(title: "WARNING", message: "Check your internet connection", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
//            NetworkMonitor.shared.startMonitoring()
//            self.checkConnection()
//        }))
        present(ac, animated: true)
    }

}
