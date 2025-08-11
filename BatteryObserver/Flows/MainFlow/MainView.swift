//
//  MainView.swift
//  BatteryObserver
//
//  Created by Bohdan Bondar on 10.08.2025
//  
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModelImpl
    
    var body: some View {
        VStack(spacing: 20) {
            startButton
            stopButton
        }
        .padding(.horizontal)
    }
}

private extension MainView {
    var startButton: some View {
        CommonButton {
            Text("Start battery monitoring")
        } action: {
            viewModel.startObserving()
        }
    }
    
    var stopButton: some View {
        CommonButton {
            Text("Stop battery monitoring")
        } action: {
            viewModel.stopObserving()
        }
    }
}

#Preview {
    MainView(viewModel: VMFactory.buildMainVM())
}
