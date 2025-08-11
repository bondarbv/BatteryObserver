//
//  NetworkService.swift
//  BatteryObserver
//
//  Created by Bohdan Bondar on 10.08.2025
//  
//

import Foundation

protocol NetworkService: AnyObject {
    func post<T: Encodable>(body: T) async throws
    func encodeToBase64<T: Encodable>(_ value: T) throws -> String
}

final class NetworkServiceImpl: NetworkService {
    func post<T: Encodable>(body: T) async throws {
        let jsonData = try JSONEncoder().encode(body)
        
        var request = URLRequest(url: Constants.baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    func encodeToBase64<T: Encodable>(_ value: T) throws -> String {
        let jsonData = try JSONEncoder().encode(value)
        return jsonData.base64EncodedString()
    }
}
