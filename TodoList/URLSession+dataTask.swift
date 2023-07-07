//
//  URLSession+dataTask.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-07.
//

import Foundation

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        
        var task: URLSessionDataTask?
        
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                task = self.dataTask(with: urlRequest) { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let data = data, let response = response {
                        continuation.resume(returning: (data, response))
                    } else {
                        let unexpectedError = NSError(domain: "UnexpectedErrorDomain", code: -1, userInfo: nil)
                        continuation.resume(throwing: unexpectedError)
                    }
                }
                task?.resume()
            }
        } onCancel: { [weak task] in
            // if we cancel the Task where this dataTask was called
            // this dataTask cancels automatically
            print("task cancelled inside URLSession")
            task?.cancel()
        }
    }
}
