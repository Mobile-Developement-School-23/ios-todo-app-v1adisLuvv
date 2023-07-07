//
//  NetworkError.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-06.
//

import Foundation

enum NetworkError: Error {
    case wrongUrl
    case unexpectedResponse
    case badResponse
    case retryFailed
}
