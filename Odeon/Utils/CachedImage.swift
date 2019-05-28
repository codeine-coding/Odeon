//
//  CachedImage.swift
//  TVQuoteApp
//
//  Created by Allen Whearry on 12/19/18.
//  Copyright © 2018 Codeine Technologies LLC. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    typealias completionHandler = () -> Void
    
    func downloadImage(from urlString: String, loadingIndicator: UIActivityIndicatorView? = nil, completion: completionHandler? = nil){
        
        // check cache for image first
        if let loadingIndicator = loadingIndicator {
            loadingIndicator.startAnimating()
        }
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            if let loadingIndicator = loadingIndicator {
                loadingIndicator.stopAnimating()
            }
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                if let data = data, let downloadedImage = UIImage(data: data) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                    if let loadingIndicator = loadingIndicator {
                        loadingIndicator.stopAnimating()
                    }
                }
                if let complete = completion {
                    complete()
                }
            }
            }.resume()
    }
    
}
