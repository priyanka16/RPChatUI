//
//  OptionCardCollectionViewCell.swift
//  RPChatterBox
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import UIKit

class OptionCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gradientImageView: UIImageView!
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var knowMoreButton: UIButton!
    
    func setupCollectionViewCell(for index: Int) {
        
        self.backgroundColor = UIColor.clear
        
        self.containerView.layer.cornerRadius = 8.0
        self.containerView.layer.borderWidth = 1.0
        self.containerView.layer.borderColor = UIColor(red: 242 / 255.0, green: 242 / 255.0, blue: 242 / 255.0, alpha: 1.0).cgColor
        self.containerView.layer.masksToBounds = true
        
        self.containerView.layer.shadowColor = UIColor(red: 230 / 255.0, green: 230 / 255.0, blue: 230 / 255.0, alpha: 1.0).cgColor
        self.containerView.layer.shadowOffset = CGSize(width: -2.0, height: 2.0)
        self.containerView.layer.shadowRadius = 2.0
        self.containerView.layer.shadowOpacity = 1.0
        self.containerView.layer.masksToBounds = false
        
        self.gradientImageView.layer.cornerRadius = 8.0
        self.gradientImageView.layer.borderWidth = 1.0
        self.gradientImageView.layer.borderColor = UIColor(red: 242 / 255.0, green: 242 / 255.0, blue: 242 / 255.0, alpha: 1.0).cgColor
        self.gradientImageView.layer.masksToBounds = true
        //self.gradientImageView.image = UIImage(named: "gradient")
        if let customBundle = Bundle(path: Bundle.main.path(forResource: "RPBundle", ofType: "bundle")!) {
            if let image = UIImage(contentsOfFile: customBundle.path(forResource: "gradient", ofType: "tiff")!) {
                self.gradientImageView.image = image
            }
        }
    }
}
