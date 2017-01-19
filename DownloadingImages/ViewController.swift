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
        
        MovieAPIManager.shared.searchMovies(query: "Jurassic Park", handler: { movies, result in
            
            print("\n")
            print("Here we are!")
            
            switch result {
                
            case .badData:
                print("Bad Data.")
            case .badSearchQuery:
                print("Bad Search Query.")
            case .success:
                print("Success!")
                
                
            }
            
        })
        
    }

  


}

