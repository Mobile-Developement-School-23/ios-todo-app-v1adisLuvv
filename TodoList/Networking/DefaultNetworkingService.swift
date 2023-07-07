//
//  DefaultNetworkingService.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-05.
//

import Foundation

final class DefaultNetworkingService: NetworkingService {
    
    private static let baseUrlSource = "https://beta.mrdekk.ru/todobackend/list"
    private static let token = "oligopolistic"
    
    private static var revision = 0
    
    private static let minDelay: TimeInterval = 2.0
    private static let maxDelay: TimeInterval = 120
    private static let factor: Double = 1.5
    private static let jitter: Double = 0.05
    
    private static func exponentialBackoffRetry<T>(operation: @escaping () async throws -> T) async throws -> T {
        var delay = minDelay
        var result: T? = nil
        
        while delay < maxDelay {
            do {
                result = try await operation()
                break
            } catch {
                // instead of DispatchQueue.async I used Task.sleep(delay)
                try await Task.sleep(nanoseconds: UInt64(delay * Double(NSEC_PER_SEC))) // does not block the underlying thread
                let jitter = delay * jitter
                delay = powl(delay, factor) + jitter
                print(delay)
            }
        }

        if let result = result {
            print(result)
            return result
        } else {
            throw NetworkError.retryFailed
        }
    }
    
    private static func makeRequestWithRetry(URL url: URL, httpMethod: HttpMethod, httpBody: Data? = nil) async throws -> (Data, HTTPURLResponse) {
        return try await exponentialBackoffRetry {
            try await makeRequest(URL: url, httpMethod: httpMethod, httpBody: httpBody)
        }
    }
    
    private static func makeRequest(URL url: URL, httpMethod: HttpMethod, httpBody: Data? = nil) async throws -> (Data, HTTPURLResponse) {
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBody
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            print(response)
            throw NetworkError.unexpectedResponse
        }
        guard (200..<300).contains(response.statusCode) else {
            print(response)
            throw NetworkError.badResponse
        }
        
        return (data, response)
    }
    
    static func loadList() async throws -> [ServerElement] {
        guard let url = URL(string: baseUrlSource) else {
            throw NetworkError.wrongUrl
        }
        let (data, _) = try await makeRequestWithRetry(URL: url, httpMethod: .get)
        let response = try JSONDecoder().decode(ServerResponseList.self, from: data)
        revision = response.revision
        print(response)
        return response.list
    }
    
    static func updateList(withList list: [ServerElement]) async throws -> [ServerElement] {
        guard let url = URL(string: baseUrlSource) else {
            throw NetworkError.wrongUrl
        }
        let request = ServerRequestList(status: "ok", list: list)
        let httpBody = try JSONEncoder().encode(request)
        let (data, _) = try await makeRequestWithRetry(URL: url, httpMethod: .patch, httpBody: httpBody)
        let response = try JSONDecoder().decode(ServerResponseList.self, from: data)
        print(response)
        revision += 1
        return response.list
    }
    
    static func loadItem(itemID id: String) async throws -> ServerElement {
        let urlSource = baseUrlSource + "/\(id)"
        guard let url = URL(string: urlSource) else {
            throw NetworkError.wrongUrl
        }
        let (data, _) = try await makeRequestWithRetry(URL: url, httpMethod: .get)
        let response = try JSONDecoder().decode(ServerResponseElement.self, from: data)
        print(response)
        return response.element
    }
    
    static func uploadItem(item: ServerElement) async throws -> ServerElement {
        guard let url = URL(string: baseUrlSource) else {
            throw NetworkError.wrongUrl
        }
        let request = ServerRequestElement(status: "ok", element: item)
        let httpBody = try JSONEncoder().encode(request)
        let (data, _) = try await makeRequestWithRetry(URL: url, httpMethod: .post, httpBody: httpBody)
        let response = try JSONDecoder().decode(ServerResponseElement.self, from: data)
        print(response)
        revision += 1
        return response.element
    }
    
    static func updateItem(itemID id: String, withItem item: ServerElement) async throws -> ServerElement {
        let urlSource = baseUrlSource + "/\(id)"
        guard let url = URL(string: urlSource) else {
            throw NetworkError.wrongUrl
        }
        let request = ServerRequestElement(status: "ok", element: item)
        let httpBody = try JSONEncoder().encode(request)
        let (data, _) = try await makeRequestWithRetry(URL: url, httpMethod: .put, httpBody: httpBody)
        let response = try JSONDecoder().decode(ServerResponseElement.self, from: data)
        print(response)
        revision += 1
        return response.element
    }
    
    @discardableResult
    static func deleteItem(itemID id: String) async throws -> ServerElement {
        let urlSource = baseUrlSource + "/\(id)"
        guard let url = URL(string: urlSource) else {
            throw NetworkError.wrongUrl
        }
        let (data, _) = try await makeRequestWithRetry(URL: url, httpMethod: .delete)
        let response = try JSONDecoder().decode(ServerResponseElement.self, from: data)
        print(response)
        revision += 1
        return response.element
    }
}
