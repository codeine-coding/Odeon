//
//  UnsplashService.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/17/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import Foundation

class UnsplashService {
    static let instance = UnsplashService()
    var photos = [UnsplashImage]()
    
    func getUnsplashPhotos(completed: @escaping () -> Void) {
        let photosURL = API.USPhotosURL
        guard let url = URL(string: photosURL) else { return }
        let request = createRequest(with: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                self.photos = try JSONDecoder().decode([UnsplashImage].self, from: data)
                DispatchQueue.main.async {
                    completed()
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func searchPhotos(query: String, completed: @escaping () -> Void) throws {
        let photoURL = "\(API.USSearchPhotosURL)\(query)"
        guard let url = URL(string: photoURL) else { return }
        let request = createRequest(with: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                guard results.total > 0 else { throw SearchError.ZeroSearch }
                self.photos = results.results
                DispatchQueue.main.async {
                    completed()
                }
            } catch {
                print(error)
            }
            }.resume()
    }
    
    
    func createRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Client-ID \(API.USAccessKey)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
