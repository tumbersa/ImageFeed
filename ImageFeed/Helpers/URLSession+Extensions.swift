//
//  URLSession+Extensions.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 05.11.2023.
//

import Foundation

//MARK: - Network Connection

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T,Error>) -> Void
    ) -> URLSessionTask{
        let fulfiilCompletion: (Result<T,Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: {data, responce, error in
            if let data,
               let responce,
               let statusCode = (responce as? HTTPURLResponse)?.statusCode
            {
                if 200..<300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        fulfiilCompletion(.success(result))
                    }
                    catch let error {
                        fulfiilCompletion(.failure(error))
                    }
                } else if !(200..<300).contains(statusCode) {
                    fulfiilCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                } else if let error {
                    fulfiilCompletion(.failure(NetworkError.urlRequestError(error)))
                } else {
                    fulfiilCompletion(.failure(NetworkError.urlSessionError))
                }
            }
        })
        return task
    }
}
