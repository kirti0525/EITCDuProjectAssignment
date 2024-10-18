//
//  PostTableViewCell.swift
//  EITCDuProjectAssignment
//
//  Created by Kirti Kalra on 16/10/24.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var favouriteImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Private Methods
    private func commonInit() {
        containerView.layer.cornerRadius = 5.0
        containerView.layer.borderColor = .init(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    
    // MARK: Public Methods
    public func configure(for post: PostDB) {
        titleLabel.text = post.title
        descriptionLabel.text = post.body
        favouriteImageView.image = post.isFavorite ? UIImage.init(named: "removeFavourites") : UIImage.init(named: "addFavourites")
    }
}
