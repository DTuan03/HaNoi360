//
//  NetworkMonitor.swift
//  HaNoi360
//
//  Created by Tuấn on 8/7/25.
//

import Foundation
import Network
import RxSwift
import RxRelay

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    private var isConnected: Bool = true

    let connectionStatus = BehaviorRelay<Bool>(value: true)

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let newStatus = path.status == .satisfied
            DispatchQueue.main.async {
                if self.isConnected != newStatus {
                    self.isConnected = newStatus
                    self.connectionStatus.accept(newStatus)
                }
            }
        }
        monitor.start(queue: queue)
    }
}

