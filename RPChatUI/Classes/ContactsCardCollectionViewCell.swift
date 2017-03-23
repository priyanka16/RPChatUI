//
//  ContactsCardCollectionViewCell.swift
//  RPChatterBox
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import UIKit
import QuartzCore

protocol ContactsCardCollectionViewCellDelegate : class {
    func didSelectContact(with contactId: Int)
}

class ContactsCardCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: ContactsCardCollectionViewCellDelegate?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gradientImageView: UIImageView!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactDesignationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!

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
        
        self.selectButton.layer.cornerRadius = 10.0
        self.selectButton.layer.borderWidth = 0.5
        self.selectButton.layer.borderColor = UIColor(red: 68 / 255.0, green: 65 / 255.0, blue: 235 / 255.0, alpha: 1.0).cgColor
        
        if let customBundle = Bundle.init(identifier: "org.cocoapods.RPChatUI")?.path(forResource: "RPBundle", ofType: "bundle") {
            if let imagePath: String = (customBundle.appending("/icConactBackground.tiff")) {
                if let image = UIImage(contentsOfFile:imagePath) {
                    gradientImageView.image = image
                }
            }
        }
        if let customBundle = Bundle.init(identifier: "org.cocoapods.RPChatUI")?.path(forResource: "RPBundle", ofType: "bundle") {
            if let imagePath: String = (customBundle.appending("/icContactImage.tiff")) {
                if let image = UIImage(contentsOfFile:imagePath) {
                    contactImage.image = image
                }
            }
        }
    }
    
    
    @IBAction func selectContact(_ sender: AnyObject) {
        
        selectButton.backgroundColor = UIColor(red: 69 / 255.0, green: 65 / 255.0, blue: 234 / 255.0, alpha: 1.0)
        self.selectButton.setTitleColor(UIColor.white, for: .normal)
        self.delegate?.didSelectContact(with: sender.tag)
    }
}

