//
//  DIContainer.swift
//  BatteryObserver
//
//  Created by Bohdan Bondar on 10.08.2025
//  
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()
    
    lazy var batteryMonitoringService: BatteryMonitoringService = {
        BatteryMonitoringServiceImpl()
    }()
    
    lazy var networkService: NetworkService = {
        NetworkServiceImpl()
    }()
    
    private init() {}
}
