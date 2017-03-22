//
//  NotesTableViewCell.swift
//  
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import UIKit

protocol NotesTableViewCellDelegate : class {
    func didTapNotesButton()
}

class NotesTableViewCell : ChatMessageCell {
    
    private let takeNotesButton = UIButton(type: .custom)
    weak var delegate: NotesTableViewCellDelegate?
    
    func setupCell(message: ChatMessage) {
        
        _ = super.computedTextAreaHeight(message: message)
        super.setupWithMessage(message: message)
        self.setupTakeNotesButton()
        self.setupTakeNotesButtonConstraints()
        if (message.sentBy == .User) {
            let targetX = (self.messageBubbleView.bounds.width / 2.0) + 5
            self.messageBubbleView.center.x = self.bounds.width - targetX - userImageView.bounds.width - 5
        } else {
            self.messageBubbleView.frame.origin.x = (self.botImageView.bounds.width + 10)
        }
    }
    
    func setupTakeNotesButton() {
        
        self.takeNotesButton.addTarget(self, action: #selector(takeNotesButtonPressed(sender:)), for: .touchUpInside)
        self.takeNotesButton.bounds = CGRect(x: 0, y: 0, width: 60, height: 1)
        self.takeNotesButton.setTitle("Take Notes", for: .normal)
        self.takeNotesButton.setTitleColor(UIColor(red: 68 / 255.0, green: 65 / 255.0, blue: 235 / 255.0, alpha: 1.0), for: .normal)
        self.takeNotesButton.titleLabel?.font = UIFont(name: "SFUIText-Light", size: 14.0)
        self.takeNotesButton.backgroundColor = UIColor.clear
        self.takeNotesButton.layer.cornerRadius = 15
        self.takeNotesButton.layer.borderWidth = 1.0
        self.takeNotesButton.layer.borderColor = UIColor(red: 68 / 255.0, green: 65 / 255.0, blue: 235 / 255.0, alpha: 1.0).cgColor
        super.messageBubbleView.addSubview(takeNotesButton)
        
    }
    
    func setupTakeNotesButtonConstraints() {
        self.takeNotesButton.translatesAutoresizingMaskIntoConstraints = false
        self.takeNotesButton.removeConstraints(self.takeNotesButton.constraints)
        
        let leadingConstraint = NSLayoutConstraint(item: self.textView, attribute: .leading, relatedBy: .equal, toItem: self.takeNotesButton, attribute: .leading, multiplier: 1.0, constant: -10)
        let topConstraint = NSLayoutConstraint(item: self.textView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: self.takeNotesButton, attribute: .top, multiplier: 1.0, constant: -5)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.takeNotesButton, attribute: .bottom, multiplier: 1.0, constant:15)
        let widthConstraint = NSLayoutConstraint(item: self.takeNotesButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        let hieghtConstraint = NSLayoutConstraint(item: self.takeNotesButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
        self.addConstraints([hieghtConstraint, widthConstraint, leadingConstraint, bottomConstraint, topConstraint])
        
        let reqSpaceNoteBtn = widthConstraint.constant + self.textView.frame.origin.x + 20 //Padding on right n left
        let widthQuotient = Int(self.textView.bounds.size.width/reqSpaceNoteBtn)
        if (widthQuotient <= 0) {
            self.messageBubbleView.bounds.size.width = reqSpaceNoteBtn
        }
    }
    
    func takeNotesButtonPressed(sender: UIButton) {
        
        self.delegate?.didTapNotesButton()
    }
    
}
