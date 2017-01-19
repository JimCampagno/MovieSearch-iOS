//
//  MovieAPIManager.swift
//  DownloadingImages
//
//  Created by Jim Campagno on 1/19/17.
//  Copyright © 2017 Jim Campagno. All rights reserved.
//

import Foundation

typealias JSON = [String : Any]


final class MovieAPIManager {
    
    static let shared = MovieAPIManager()
    private let baseURLString = "http://www.omdbapi.com/"
    
    
    private init() { }
    
    
    func searchMovies(query: String, handler: @escaping ([Movie]?, MovieResult) -> Void) {
        guard let search = generateString(with: query),
            let url = generateURL(with: search)
            else { handler(nil, .badSearchQuery); return }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        session.dataTask(with: request, completionHandler: { [unowned self] data, response, error in
            DispatchQueue.main.async {
                guard let json = self.generateJSON(with: data) else { handler(nil, .badData); return }
                print("JSON:\n \(json)")
                
                // TODO: Update this.
                handler(nil, .success)
            }
        }).resume()
    }
    
    private func generateJSON(with data: Data?) -> JSON? {
        guard let rawData = data,
            let rawJSON = try? JSONSerialization.jsonObject(with: rawData, options: .allowFragments)
            else { return nil }
        return rawJSON as? JSON
    }
    
    private func generateString(with query: String) -> String? {
        return query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    private func generateURL(with query: String) -> URL? {
        let string = baseURLString + "?s=\(query)" + "&plot=short" + "&r=json"
        return URL(string: string)
    }
    
    
    
}
