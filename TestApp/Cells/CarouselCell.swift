//
//  CarouselCell.swift
//  TestApp
//
//  Created by Ashu on 17/12/24.
//

import UIKit

class CarouselCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    static let cellID = "CarouselCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }

}
