//
//  NetworkService.swift
//  Odeon
//
//  Created by Allen Whearry on 5/26/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noResponse
    case invalidCredentials
    case clientError
    case serverError
    case unknownError

    static func from(httpCode: Int) -> NetworkError? {
        switch httpCode {
        case 200...299, 300...399:
            // these represent successis, no error
            return nil
        case 400, 401:
            return .invalidCredentials
        case 402...499:
            return .clientError
        case 500...599:
            return .serverError
        default:
            return .unknownError
        }
    }
}

final class NetworkService {
    static let shared = NetworkService()

    private init() {}

    func get<T:Codable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) { // -> URLSessionTask where T: Decodable {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

            guard error == nil else {
                completion(.failure(error!))
                return
            }


            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.noResponse))
                return
            }

            if NetworkError.from(httpCode: response.statusCode) != nil {
                completion(.failure(NetworkError.from(httpCode: response.statusCode)!))
            }



            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
