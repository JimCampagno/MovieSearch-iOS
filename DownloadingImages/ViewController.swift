//
//  ViewController.swift
//  DownloadingImages
//
//  Created by Jim Campagno on 1/18/17.
//  Copyright © 2017 Jim Campagno. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  testOtherThing()
        
       // fethFilmsDude()

    }
    
    func testOtherThing() {
        
        let manager = MovieManager()
        
        let onlyTheBest = manager.fetchFavorites()
        
        print("\nFavoritedFilms:")
        
        print(onlyTheBest)
        
    }
    
    func fethFilmsDude() {
        
        MovieAPIManager.shared.searchMovies(query: "The Matrix", handler: { movies, result in
            
            print("\n")
            switch result {
                
            case .badData:
                print("Bad Data.")
            case .badSearchQuery:
                print("Bad Search Query.")
            case .success:
                print("Success!")
                CoreDataStack.shared.saveContext()
                

                
            }
            
        })
    }

  


}

