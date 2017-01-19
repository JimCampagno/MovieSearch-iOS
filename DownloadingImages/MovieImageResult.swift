//
//  MovieImageResult.swift
//  DownloadingImages
//
//  Created by Jim Campagno on 1/19/17.
//  Copyright © 2017 Jim Campagno. All rights reserved.
//

import Foundation

// TODO: Not using throws in any function. Could remove Error here.
enum MovieImageResult: Error {
    
    case isDownloading
    case badURL
    case noData
    case badImage
    case couldNotLoadImage
    case localSuccess
    case downloadSuccess
    
}
