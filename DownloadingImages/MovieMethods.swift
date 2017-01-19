//
//  MovieMethods.swift
//  DownloadingImages
//
//  Created by Jim Campagno on 1/18/17.
//  Copyright © 2017 Jim Campagno. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Image Methods
extension Movie {
    
    func retrieveImage(handler: @escaping (UIImage?, MovieImageResult) -> Void) {
        if let location = localImageURL {
            guard let image = UIImage.loadImage(at: location) else { handler(nil, .couldNotLoadImage); return }
            handler(image, .localSuccess)
        }
        
        downloadImage(handler: handler)
    }
    
   private func downloadImage(handler: @escaping (UIImage?, MovieImageResult) -> Void) {
        guard !isDownloadingImage else { handler(nil, .isDownloading); return }
        isDownloadingImage = true
        guard let string = imageLocation, let url = URL(string: string) else { handler(nil, .badURL); return }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        session.dataTask(with: request, completionHandler: { [unowned self] data, response, error in
            guard let rawData = data else { handler(nil, .noData); return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: rawData) else { handler(nil, .badImage); return }
                self.localImageURL = image.save(name: self.id!)
                handler(image, .downloadSuccess)
            }
        }).resume()
    }
    
}
