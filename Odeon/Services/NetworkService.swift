//
//  NetworkService.swift
//  Odeon
//
//  Created by Allen Whearry on 5/26/19.
//  Copyright © 2019 Allen Whearry. All rights reserved.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()

    private init() {}

    func get<T:Codable>(url: URL, completion: @escaping (T?, Error?) -> Void) { // -> URLSessionTask where T: Decodable {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            else {
                completion(nil, nil)
                return
            }

            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(result, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
