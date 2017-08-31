//
//  NoddyTableViewCell.swift
//  
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import UIKit

protocol NoddyTableViewCellDelegate : class {
    func didTapYesButton()
    func didTapNoButton()
}

class NoddyTableViewCell: ChatMessageCell {
    
    private let yesButton = UIButton(type: .custom)
    private let noButton = UIButton(type: .custom)
    weak var delegate: NoddyTableViewCellDelegate?
    
    func setupCell(message: ChatMessage) {
        
        _ = super.computedTextAreaHeight(message: message)
        super.setupWithMessage(message: message)
        self.setupYESButton()
        self.setupNOButton()
        self.setupYESButtonConstraints()
        self.setupNOButtonConstraints()
        if (message.sentBy == .User) {
            let targetX = (self.messageBubbleView.bounds.width / 2.0) + 5
            self.messageBubbleView.center.x = self.bounds.width - targetX - userImageView.bounds.width - 5
        } else {
            self.messageBubbleView.frame.origin.x = (self.botImageView.bounds.width + 10)
        }
    }
    
    func setupYESButton() {
        
        self.yesButton.addTarget(self, action: #selector(yesButtonPressed(sender:)), for: .touchUpInside)
        self.yesButton.bounds = CGRect(x: 0, y: 0, width: 50, height: 1)
        self.yesButton.setTitle("YES", for: .normal)
        self.yesButton.setTitleColor(UIColor(red: 68 / 255.0, green: 65 / 255.0, blue: 235 / 255.0, alpha: 1.0), for: .normal)
        self.yesButton.titleLabel?.font = UIFont(name: "SFUIText-Light", size: 14.0)
        self.yesButton.backgroundColor = UIColor.clear
        self.yesButton.layer.cornerRadius = 15
        self.yesButton.layer.borderWidth = 1.0
        self.yesButton.layer.borderColor = UIColor(red: 68 / 255.0, green: 65 / 255.0, blue: 235 / 255.0, alpha: 1.0).cgColor
        super.messageBubbleView.addSubview(yesButton)
        
    }
    
    func setupNOButton() {
        
        self.noButton.addTarget(self, action: #selector(noButtonPressed(sender:)), for: .touchUpInside)
        self.noButton.bounds = CGRect(x: 0, y: 0, width: 50, height: 1)
        self.noButton.setTitle("NO", for: .normal)
        self.noButton.setTitleColor(UIColor(red: 68 / 255.0, green: 65 / 255.0, blue: 235 / 255.0, alpha: 1.0), for: .normal)
        self.noButton.titleLabel?.font = UIFont(name: "SFUIText-Light", size: 14.0)
        self.noButton.backgroundColor = UIColor.clear
        self.noButton.layer.cornerRadius = 15
        self.noButton.layer.borderWidth = 1.0
        self.noButton.layer.borderColor = UIColor(red: 68 / 255.0, green: 65 / 255.0, blue: 235 / 255.0, alpha: 1.0).cgColor
        super.messageBubbleView.addSubview(noButton)
        
    }
    
    func setupYESButtonConstraints() {
        self.yesButton.translatesAutoresizingMaskIntoConstraints = false
        self.yesButton.removeConstraints(self.yesButton.constraints)
        
        let leadingConstraint = NSLayoutConstraint(item: self.textView, attribute: .leading, relatedBy: .equal, toItem: self.yesButton, attribute: .leading, multiplier: 1.0, constant: -10)
        
        let topConstraint = NSLayoutConstraint(item: self.textView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: self.yesButton, attribute: .top, multiplier: 1.0, constant: -5)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.yesButton, attribute: .bottom, multiplier: 1.0, constant:15)
        let widthConstraint = NSLayoutConstraint(item: self.yesButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        let hieghtConstraint = NSLayoutConstraint(item: self.yesButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
        self.addConstraints([hieghtConstraint, widthConstraint, leadingConstraint, bottomConstraint, topConstraint])
        
    }
    
    func setupNOButtonConstraints() {
        self.noButton.translatesAutoresizingMaskIntoConstraints = false
        self.noButton.removeConstraints(self.noButton.constraints)
        
        let leftConstraint = NSLayoutConstraint(item: self.yesButton, attribute: .trailing, relatedBy: .equal, toItem: self.noButton, attribute: .leading, multiplier: 1, constant: -10)
        let centerConstraint = NSLayoutConstraint(item: self.yesButton, attribute: .centerY, relatedBy: .equal, toItem: self.noButton, attribute: .centerY, multiplier: 1.0, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: self.noButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        let hieghtConstraint = NSLayoutConstraint(item: self.noButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
        self.addConstraints([hieghtConstraint, widthConstraint, leftConstraint, centerConstraint])
        
        let reqSpaceNoteBtn = (2 * widthConstraint.constant) + self.textView.frame.origin.x + 20 //Padding on right n left
         let widthQuotient = Int(self.textView.bounds.size.width/reqSpaceNoteBtn)
         if (widthQuotient <= 0) {
         self.messageBubbleView.bounds.size.width = reqSpaceNoteBtn
         let targetX = (self.messageBubbleView.bounds.width / 2.0) + 5
         self.messageBubbleView.center.x = self.bounds.width - targetX - userImageView.bounds.width - 5
         }
    }
    
    func yesButtonPressed(sender: UIButton) {
        
        if (yesButton.backgroundColor == UIColor.white) {
            yesButton.backgroundColor = UIColor(red: 69 / 255.0, green: 65 / 255.0, blue: 234 / 255.0, alpha: 1.0)
            self.yesButton.setTitleColor(UIColor.white, for: .normal)
            self.delegate?.didTapYesButton()
        } else {
            yesButton.backgroundColor = UIColor.white
            self.yesButton.setTitleColor(UIColor(red: 69 / 255.0, green: 65 / 255.0, blue: 234 / 255.0, alpha: 1.0), for: .normal)
        }
    }
    
    func noButtonPressed(sender: UIButton) {
        
        if (noButton.backgroundColor == UIColor.white) {
            noButton.backgroundColor = UIColor(red: 69 / 255.0, green: 65 / 255.0, blue: 234 / 255.0, alpha: 1.0)
            noButton.setTitleColor(UIColor.white, for: .normal)
            self.delegate?.didTapNoButton()
        } else {
            noButton.backgroundColor = UIColor.white
            noButton.setTitleColor(UIColor(red: 69 / 255.0, green: 65 / 255.0, blue: 234 / 255.0, alpha: 1.0), for: .normal)
        }
    }
    
}
