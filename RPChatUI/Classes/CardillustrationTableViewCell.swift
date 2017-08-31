//
//  CardillustrationTableViewCell.swift
//  RPChatterBox
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import UIKit

class CardillustrationTableViewCell : UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var demonstrationImageView: UIImageView!
    @IBOutlet weak var demonstrationTitle: UILabel!
    @IBOutlet weak var demonstrationDescription: UILabel!
    
    func setupCell(cardObject: Dictionary<String, String>) {
        
        self.backgroundColor = UIColor.clear
        self.containerView.layer.cornerRadius = 8.0
        self.containerView.layer.borderWidth = 1.0
        self.containerView.layer.borderColor = UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1.0).cgColor
        //self.containerView.layer.masksToBounds = true
        
        self.containerView.layer.shadowColor = UIColor(red: 220 / 255.0, green: 220 / 255.0, blue: 220 / 255.0, alpha: 1.0).cgColor
        self.containerView.layer.shadowOffset = CGSize(width: -2.0, height: 2.0)
        self.containerView.layer.shadowRadius = 2.0
        self.containerView.layer.shadowOpacity = 1.0
        self.containerView.layer.masksToBounds = false
        
        self.demonstrationImageView.layer.cornerRadius = 8.0
        self.demonstrationImageView.layer.borderWidth = 1.0
        self.demonstrationImageView.layer.borderColor = UIColor(red: 242 / 255.0, green: 242 / 255.0, blue: 242 / 255.0, alpha: 1.0).cgColor
        self.demonstrationImageView.layer.masksToBounds = true
        if let demoImage = cardObject["demoImage"] {

            if let customBundle = Bundle.init(identifier: "org.cocoapods.RPChatUI")?.path(forResource: "RPBundle", ofType: "bundle") {
                if let imagePath: String = (customBundle.appending("/\(demoImage).jpg")) {
                    if let demoImageFile = UIImage(contentsOfFile:imagePath) {
                        self.demonstrationImageView.image = demoImageFile
                    }
                }
            }
        }
        if let demoTitle = cardObject["demoTitle"] {
            self.demonstrationTitle.text = demoTitle
        }
        
        if let demoDescpt = cardObject["demoDescription"] {
            self.demonstrationDescription.text = demoDescpt
        }
    }
}
