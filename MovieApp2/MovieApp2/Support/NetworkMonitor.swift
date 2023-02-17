//
//  NetworkMonitor.swift
//  MovieApp2
//
//  Created by Burak Erden on 16.02.2023.
//

import Foundation
import Network
import UIKit

class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    var connectionStatus: Bool = true
//
//    func checkNetwork() {
//        let monitor = NWPathMonitor()
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                DispatchQueue.main.async {
//                    print("connected")
//                }
//            } else {
//                DispatchQueue.main.async {
//                    print("not connected")
//                    self.connectionStatus = false
//                }
//            }
//        }
//        let queue = DispatchQueue(label: "Network")
//        monitor.start(queue: queue)
//    }
    

    
}
