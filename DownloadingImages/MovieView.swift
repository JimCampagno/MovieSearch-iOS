//
//  MovieView.swift
//  DownloadingImages
//
//  Created by Jim Campagno on 1/18/17.
//  Copyright © 2017 Jim Campagno. All rights reserved.
//

import Foundation
import UIKit

protocol MovieViewDelegate: class {
    func canDisplayImage(movie: Movie) -> Bool
}

final class MovieView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieImdbLabel: UILabel!
    
    weak var movieViewDelegate: MovieViewDelegate?
    
    var movie: Movie! {
        didSet {
            movieSetup()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MovieView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    private func movieSetup() {
        movie.retrieveImage { [unowned self] image, result in
            
            guard let delegate = self.movieViewDelegate,
            delegate.canDisplayImage(movie: self.movie),
            let image = image
                else { return }
        
            switch result {
            case .localSuccess:
                self.updateViews(withImage: image)
            case .downloadSuccess:
                self.updateViews(withImage: image, animated: true)
            default:
                print("Unable to retrieve image.")
            }
        }
    }
    
    private func updateViews(withImage image: UIImage, animated: Bool = false) {
        self.movieImageView.image = image
        self.movieTitleLabel.text = self.movie.title
        self.movieImdbLabel.text = self.movie.imdbRating
        
        if animated {
            UIView.animate(withDuration: 0.8, animations: {
                self.movieImageView.alpha = 1.0
                self.movieTitleLabel.alpha = 1.0
                self.movieImdbLabel.alpha = 1.0
            }, completion: { _ in })
        } else {
            self.movieImageView.alpha = 1.0
            self.movieTitleLabel.alpha = 1.0
            self.movieImdbLabel.alpha = 1.0
        }
    }
    
}
