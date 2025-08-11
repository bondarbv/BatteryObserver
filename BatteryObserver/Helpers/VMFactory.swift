//
//  VMFactory.swift
//  BatteryObserver
//
//  Created by Bohdan Bondar on 10.08.2025
//  
//

import Foundation

enum VMFactory {
    static func buildMainVM() -> MainViewModelImpl {
        let networkService = DIContainer.shared.networkService
        let batteryMonitoringService = DIContainer.shared.batteryMonitoringService
        let batteryObservingInteractor = BatteryObservingInteractor(
            networkService: networkService,
            batteryMonitoringService: batteryMonitoringService
        )
        return MainViewModelImpl(batteryObservingInteractor: batteryObservingInteractor)
    }
}
