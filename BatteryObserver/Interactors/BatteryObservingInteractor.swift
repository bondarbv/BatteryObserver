//
//  BatteryObservingInteractor.swift
//  BatteryObserver
//
//  Created by Bohdan Bondar on 10.08.2025
//  
//

import Foundation
import Combine

final class BatteryObservingInteractor {
    private let networkService: NetworkService
    private let batteryMonitoringService: BatteryMonitoringService
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(networkService: NetworkService, batteryMonitoringService: BatteryMonitoringService) {
        self.networkService = networkService
        self.batteryMonitoringService = batteryMonitoringService
    }
    
    func start() {
        batteryMonitoringService.startMonitoring()
        batteryMonitoringService
            .batteryLevelJSONData
            .sink { [weak networkService] data in
                let base64Data = try? networkService?.encodeToBase64(data)
                Task {
                    try? await networkService?.post(body: base64Data)
                }
            }
            .store(in: &cancellables)
    }
    
    func stop() {
        batteryMonitoringService.stopMonitoring()
    }
}
