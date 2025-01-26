//
//  NetworkManager.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}
protocol NetworkManagerProtocol {

    func request<T: Decodable, U: Encodable>(
        url: APIEndpoints,
        method: HTTPMethod,
        requestBody: U?,
        headers: [String: String]?,
        responseType: T.Type
    ) async throws -> T
}

final class NetworkManager: NetworkManagerProtocol {
    static var shared: NetworkManagerProtocol = NetworkManager() 

    private init() {}
   
    
    enum NetworkError: Error {
        case invalidURL
        case noData
        case decodingError
        case serverError(statusCode: Int)
        case unknownError
    }
    
    
    func request<T: Decodable, U: Encodable>(
        url: APIEndpoints,
        method: HTTPMethod = .GET,
        requestBody: U? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        guard let url = URL(string: url.urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // If request body is provided, encode it into JSON
        if let body = requestBody {
            do {
                request.httpBody = try JSONEncoder().encode(body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw NetworkError.decodingError
            }
        }
        
        // Adding custom headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Perform the network request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check the HTTP response status code
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        // Decode the response data into the response model
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingError
        }
    }
}
