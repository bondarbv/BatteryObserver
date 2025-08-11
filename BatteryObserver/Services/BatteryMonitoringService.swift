//
//  BatteryMonitoringService.swift
//  BatteryObserver
//
//  Created by Bohdan Bondar on 10.08.2025
//
//


import Foundation
import UIKit
import Combine

protocol BatteryMonitoringService: AnyObject {
    var batteryLevelJSONData: PassthroughSubject<Data, Never> { get }
    func startMonitoring()
    func stopMonitoring()
}

final class BatteryMonitoringServiceImpl: BatteryMonitoringService {
    var batteryLevelJSONData = PassthroughSubject<Data, Never>()
    
    private var isBackground = false
    private var timer: AnyCancellable?
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
    private var didEnterBackgroundListener: Task<Void, Never>?
    private var willEnterForegroundListener: Task<Void, Never>?
    
    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    func startMonitoring() {
        setupListeners()
        timer = Timer
            .publish(every: 120, on: .main, in: .common)
            .autoconnect()
            .prepend(.now)
            .sink { [weak self] _ in
                self?.startBackgroundTaskIfNeeded()
                self?.sendData()
            }
    }
    
    func stopMonitoring() {
        timer?.cancel()
        didEnterBackgroundListener?.cancel()
        willEnterForegroundListener?.cancel()
        timer = nil
        didEnterBackgroundListener = nil
        willEnterForegroundListener = nil
    }
    
    private func sendData() {
        let level = getBattetyLevel()
        if let data = try? makeBatteryPercentageJSON(from: level) {
            batteryLevelJSONData.send(data)
        }
    }
    
    private func startBackgroundTaskIfNeeded() {
        if isBackground, backgroundTaskIdentifier == .invalid {
            backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask { [weak self] in
                self?.stopBackgroundTask()
            }
        }
    }
    
    private func stopBackgroundTask() {
        UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
        backgroundTaskIdentifier = .invalid
    }
    
    private func getBattetyLevel() -> Float {
        return UIDevice.current.batteryLevel
    }
    
    private func makeBatteryPercentageJSON(from level: Float) throws -> Data {
        let percentage = Int(level * 100)
        let jsonObject: [String: Any] = ["percentage": percentage]
        return try JSONSerialization.data(withJSONObject: jsonObject, options: [])
    }
    
    private func setupListeners() {
        didEnterBackgroundListener = Task {
            for await _ in NotificationCenter.default.notifications(named: UIApplication.didEnterBackgroundNotification) {
                isBackground = true
            }
        }
        
        willEnterForegroundListener = Task {
            for await _ in NotificationCenter.default.notifications(named: UIApplication.willEnterForegroundNotification) {
                isBackground = false
                if backgroundTaskIdentifier != .invalid {
                    stopBackgroundTask()
                }
            }
        }
    }
}
