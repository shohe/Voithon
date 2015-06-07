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
    
    func setCell(thumbnail: String, place: String, name: String) {
        
//        self.thumbnail.image = urlToImage(thumbnail)
        placeLabel.text = place
        nameLabel.text = name
        
        //img
        let url = NSURL(string:thumbnail)
        let req = NSURLRequest(URL:url!)
        NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
            let image = UIImage(data:data)
            self.thumbnail.image = image!
        }
    }
    
    func thumbnailToCircle() {
        self.thumbnail.layer.borderColor = UIColor.VoithonThumbBorder().CGColor
        self.thumbnail.layer.borderWidth = 3
        self.thumbnail.layer.cornerRadius = self.thumbnail.frame.size.width/2
        self.thumbnail.layer.masksToBounds = true
    }
    
    func urlToImage(URL: String) -> UIImage? {
        let url = NSURL(string:URL)
        let req = NSURLRequest(URL:url!)
        var img = UIImage()
        
        NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
            let image = UIImage(data:data)
            img = image!
        }
        return img
    }

}
