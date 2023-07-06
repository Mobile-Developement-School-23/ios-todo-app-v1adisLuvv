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
    
    private static func makeRequest(URL url: URL, httpMethod: HttpMethod, httpBody: Data? = nil) async throws -> (Data, HTTPURLResponse) {
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        request.httpBody = httpBody
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("30", forHTTPHeaderField: "X-Last-Known-Revision")
        
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
        let (data, _) = try await makeRequest(URL: url, httpMethod: .get)
        let response = try JSONDecoder().decode(ServerResponseList.self, from: data)
        print(response)
        return response.list
    }
    
    static func updateList(withList list: [ServerElement]) async throws -> [ServerElement] {
        guard let url = URL(string: baseUrlSource) else {
            throw NetworkError.wrongUrl
        }
        let request = ServerRequestList(status: "ok", list: list)
        let httpBody = try JSONEncoder().encode(request)
        let (data, _) = try await makeRequest(URL: url, httpMethod: .patch, httpBody: httpBody)
        let response = try JSONDecoder().decode(ServerResponseList.self, from: data)
        print(response)
        return response.list
    }
    
    static func loadItem(itemID id: String) async throws -> ServerElement {
        let urlSource = baseUrlSource + "/\(id)"
        guard let url = URL(string: urlSource) else {
            throw NetworkError.wrongUrl
        }
        let (data, _) = try await makeRequest(URL: url, httpMethod: .get)
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
        let (data, _) = try await makeRequest(URL: url, httpMethod: .post, httpBody: httpBody)
        let response = try JSONDecoder().decode(ServerResponseElement.self, from: data)
        print(response)
        return response.element
    }
    
    static func updateItem(itemID id: String, withItem item: ServerElement) async throws -> ServerElement {
        let urlSource = baseUrlSource + "/\(id)"
        guard let url = URL(string: urlSource) else {
            throw NetworkError.wrongUrl
        }
        let request = ServerRequestElement(status: "ok", element: item)
        let httpBody = try JSONEncoder().encode(request)
        let (data, _) = try await makeRequest(URL: url, httpMethod: .put, httpBody: httpBody)
        let response = try JSONDecoder().decode(ServerResponseElement.self, from: data)
        print(response)
        return response.element
    }
    
    static func deleteItem(itemID id: String) async throws -> ServerElement {
        let urlSource = baseUrlSource + "/\(id)"
        guard let url = URL(string: urlSource) else {
            throw NetworkError.wrongUrl
        }
        let (data, _) = try await makeRequest(URL: url, httpMethod: .delete)
        let response = try JSONDecoder().decode(ServerResponseElement.self, from: data)
        print(response)
        return response.element
    }
}
