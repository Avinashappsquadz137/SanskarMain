//
//  ApiClient.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 25/04/26.
//  Copyright © 2026 MAC MINI. All rights reserved.
//

import Foundation
import UIKit

enum ApiMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

final class ApiClient {
    
    static let shared = ApiClient()
    private init() {}
    
    func request<T: Decodable>(
        endpoint: String,
        method: ApiMethod,
        parameters: [String: Any] = [:],
        isMultipart: Bool = false,
        images: [String: Data] = [:]
    ) async throws -> T {
        
        let url = try buildURL(endpoint: endpoint, method: method, params: parameters)
        print("""
          🌍 API REQUEST
          -------------------
          🔗 URL: \(url.absoluteString)
          📤 Method: \(method.rawValue)
          📦 Params: \(parameters)
          -------------------
          """)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = setHeader()
        
        if isMultipart {
            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = createMultipartBody(
                params: parameters,
                images: images,
                boundary: boundary
            )
        } else if method != .get {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response)
        if let http = response as? HTTPURLResponse {
            print("✅ Status Code:", http.statusCode)
        }
        
        // ✅ Raw JSON
        if let jsonObject = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(
            withJSONObject: jsonObject,
            options: [.prettyPrinted]
           ),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            
            print("""
            📦 API RAW RESPONSE:
            -------------------
            \(prettyString)
            -------------------
            """)
        }
        
        let decoded = try JSONDecoder().decode(T.self, from: data)
        
        return decoded
    }
}

extension ApiClient {
    
    private func buildURL(
        endpoint: String,
        method: ApiMethod,
        params: [String: Any]
    ) throws -> URL {

        let baseURL = APIManager.sharedInstance.KBASEURL
        let fullUrl = endpoint.hasPrefix("http")
            ? endpoint
            : baseURL.trimmingCharacters(in: CharacterSet(charactersIn: "/")) + "/" + endpoint.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        
        guard var components = URLComponents(string: fullUrl) else {
            throw URLError(.badURL)
        }
        
        if method == .get {
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        return url
    }
}

extension ApiClient {
    
    private func createMultipartBody(
        params: [String: Any],
        images: [String: Data],
        boundary: String
    ) -> Data {
        
        var body = Data()
        
        // Text parameters
        for (key, value) in params {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
        
        // Images
        for (key, data) in images {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(data)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        return body
    }
}
extension ApiClient {
    
    private func validate(response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(http.statusCode) else {
            throw NSError(
                domain: "API Error",
                code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "Server Error \(http.statusCode)"]
            )
        }
    }
    
    private func setHeader() -> [String: String] {
        return [:
                    // "Authorization": "Bearer token"
                // "device_type": "2"
        ]
    }
}
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

