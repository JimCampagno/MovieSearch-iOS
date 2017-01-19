//
//  UIImageExtensions.swift
//  DownloadingImages
//
//  Created by Jim Campagno on 1/18/17.
//  Copyright © 2017 Jim Campagno. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func save(name: String) -> String? {
        guard let data = UIImagePNGRepresentation(self) else { return nil }
        let fileName = documentsDirectory().appendingPathComponent("\(name).png")
        do {
            try data.write(to: fileName)
            return String(describing: fileName)
        } catch {
            return nil
        }
    }
    
    static func loadImage(at location: String) -> UIImage? {
        return UIImage(contentsOfFile: location) ?? nil
    }
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths.first!
        return documentsDirectory
    }
    
}
