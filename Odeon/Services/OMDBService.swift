//
//  OMDBService.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/19/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import Foundation

class OMDBService {
    static let instance = OMDBService()
    
    var filmOMDB = FilmOMDB()
    
    func getFilmInfo(with imdbID: String, completed: @escaping () -> Void) {
        let filmInfoURL = "https://www.omdbapi.com/?i=\(imdbID)&plot=full&apikey=\(Environment.OMDBApiKey)"
        guard let url = URL(string: filmInfoURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                self.filmOMDB = try JSONDecoder().decode(FilmOMDB.self, from: data)
                DispatchQueue.main.async {
                    completed()
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}
