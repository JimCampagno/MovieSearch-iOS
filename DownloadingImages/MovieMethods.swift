//
//  MovieMethods.swift
//  DownloadingImages
//
//  Created by Jim Campagno on 1/18/17.
//  Copyright © 2017 Jim Campagno. All rights reserved.
//

import Foundation
import UIKit
import CoreData


// MARK: - Init Methods
extension Movie {
    
    convenience init(json: JSON, tempStorage: Bool = true) {
        self.init(context: CoreDataStack.shared.context)
        if tempStorage {
            CoreDataStack.shared.addMovieToTempStorage(self)
        }
        setupProperties(with: json, isSaved: !tempStorage)
    }
    
    private func setupProperties(with json: JSON, isSaved: Bool) {
        guard !isSaved else { setupSavedProperties(with: json); return }
        title = json["Title"] as? String
        id = json["imdbID"] as? String
        posterUrlString = json["Poster"] as? String
        year = json["Year"] as? String
        isDownloadingImage = false
        isFavorited = false
    }
    
    private func setupSavedProperties(with json: JSON) {
        title = json["Title"] as? String
        id = json["imdbID"] as? String
        posterUrlString = json["Poster"] as? String
        year = json["Year"] as? String
        isDownloadingImage = json["DownloadingImage"] as! Bool
        isFavorited = json["IsFavorited"] as! Bool
        localImageURL = json["LocalImageURL"] as? String
        imdbRating = json["Rating"] as? String
    }
    
    func serialize() -> JSON {
        return [
            "Title" : title ?? "n/a",
            "imdbID" : id ?? "n/a",
            "Poster" : posterUrlString ?? "n/a",
            "Year" : year ?? "n/a",
            "DownloadingImage" : isDownloadingImage,
            "IsFavorited" : isFavorited,
            "LocalImageURL" : localImageURL ?? "n/a",
            "Rating" : imdbRating ?? "n/a"
        ]
    }
    
    override public var description: String {
        return "\n\(title)"
    }
    
}

// MARK: - Save
extension Movie {
    
    func saveToFavorites() -> Movie {
        return CoreDataStack.shared.addMovieToMainStorage(self)
    }
    
}


// MARK: - Fetch
extension Movie {
    
    static var fetch: NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }
    
}


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
        guard let string = posterUrlString, let url = URL(string: string) else { handler(nil, .badURL); return }
        
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
