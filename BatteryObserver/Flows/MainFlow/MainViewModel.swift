//
//  MainViewModel.swift
//  BatteryObserver
//
//  Created by Bohdan Bondar on 10.08.2025
//  
//

import Foundation

protocol MainViewModel: AnyObject {
    func startObserving()
    func stopObserving()
}

final class MainViewModelImpl: MainViewModel, ObservableObject {
    private let batteryObservingInteractor: BatteryObservingInteractor
    
    init(batteryObservingInteractor: BatteryObservingInteractor) {
        self.batteryObservingInteractor = batteryObservingInteractor
    }
    
    func startObserving() {
        batteryObservingInteractor.start()
    }
    
    func stopObserving() {
        batteryObservingInteractor.stop()
    }
}
