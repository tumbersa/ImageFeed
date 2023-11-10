//
//  URLRequest+Extensions.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 05.11.2023.
//

import Foundation

//MARK: - HTTP Request

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String = "GET",
        baseUrl: URL = defaultBaseURL
    ) -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseUrl) else {
            fatalError("Invalid url")
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}

