//
//  VoithonCell.swift
//  Voithon
//
//  Created by SHOHE on 6/7/15.
//  Copyright (c) 2015 OhtaniShohe. All rights reserved.
//

import UIKit

class VoithonCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailToCircle()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(thumbnail: UIImage, place: String, name: String) {
        self.thumbnail.image = thumbnail
        placeLabel.text = place
        nameLabel.text = name
    }
    
    func thumbnailToCircle() {
        self.thumbnail.layer.borderColor = UIColor.VoithonThumbBorder().CGColor
        self.thumbnail.layer.borderWidth = 3
        self.thumbnail.layer.cornerRadius = self.thumbnail.frame.size.width/2
        self.thumbnail.layer.masksToBounds = true

    }

}
