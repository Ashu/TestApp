//
//  TableViewCell.swift
//  TestApp
//
//  Created by Ashu on 18/12/24.
//

import UIKit

class TableViewCell: UITableViewCell {
    static let cellID = "TableViewCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 12
        cellImageView.layer.masksToBounds = true
        cellImageView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with image: UIImage?, title: String, subtitle: String) {
        cellImageView.image = image
        titleLabel.text = title
        subTitleLabel.text = subtitle
    }
    
}
