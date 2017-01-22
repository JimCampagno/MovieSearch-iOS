//
//  MovieManager.swift
//  DownloadingImages
//
//  Created by Jim Campagno on 1/21/17.
//  Copyright © 2017 Jim Campagno. All rights reserved.
//

import Foundation


final class MovieManager {
    
    func fetchFavorites() -> [Movie] {
        
        let movies = try! CoreDataStack.shared.context.fetch(Movie.fetch)
        
        return movies
        
    }
    
    
    
}
