//
//  ChatMessageCell.swift
//  Chismoso
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import UIKit
import Foundation

class ChatMessageCell : UITableViewCell {
    
    // MARK: Global MessageCell Appearance Modifier
    
    struct Appearance {
        static var botColor = UIColor(red: 0.142954, green: 0.60323, blue: 0.862548, alpha: 0.88)
        static var userColor = UIColor(red: 0.14726, green: 0.838161, blue: 0.533935, alpha: 1)
        static var font: UIFont = UIFont.systemFont(ofSize: 17.0)
    }
    
    lazy var messageBubbleView: UIView = {
        let messageContainerView = UIView(frame: CGRect.zero)
        messageContainerView.backgroundColor = UIColor(red: 237/255.0, green: 239/255.0, blue: 241/255.0, alpha: 1)
        messageContainerView.layer.cornerRadius = 15
        messageContainerView.layer.borderWidth = 0.5
        messageContainerView.layer.borderColor = UIColor(red: 237/255.0, green: 239/255.0, blue: 241/255.0, alpha: 1).cgColor
        self.contentView.addSubview(messageContainerView)
        return messageContainerView
    }()
    
    // MARK: Message Bubble
    
    lazy var textView: UITextView = {
        let textView = UITextView(frame: CGRect.zero)
        textView.font = Appearance.font
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainerInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        textView.textColor = UIColor(red: 49/255.0, green: 63/255.0, blue: 72/255.0, alpha: 1)
        textView.backgroundColor = UIColor.clear
        self.messageBubbleView.addSubview(textView)
        return textView
    }()
    
    // MARK: ImageView
    
    lazy var botImageView: UIView = {
        
        let opponentImageContainer = UIView()
        opponentImageContainer.isHidden = true
        opponentImageContainer.bounds.size = CGSize(width: self.minimumHeight + 5, height: self.minimumHeight+5)
        let halfWidth = opponentImageContainer.bounds.width / 2.0
        let halfHeight = opponentImageContainer.bounds.height / 2.0
        
        // Center the imageview vertically to the textView when it is singleLine
        let textViewSingleLineCenter = self.textView.textContainerInset.top + (Appearance.font.lineHeight / 2.0)
        opponentImageContainer.center = CGPoint(x: self.padding + halfWidth, y: textViewSingleLineCenter)
        opponentImageContainer.backgroundColor = UIColor(red: 237/255.0, green: 239/255.0, blue: 241/255.0, alpha: 1)
        opponentImageContainer.layer.rasterizationScale = UIScreen.main.scale
        opponentImageContainer.layer.shouldRasterize = true
        opponentImageContainer.layer.cornerRadius = halfHeight
        opponentImageContainer.layer.masksToBounds = true
        
        let chatbotIcon = UIImageView()
        chatbotIcon.bounds.size = CGSize(width: 32, height: 32)
        chatbotIcon.center = CGPoint(x:(self.minimumHeight + 5)/2, y:(self.minimumHeight + 5)/2)
        if let customBundle = Bundle(path: Bundle.main.path(forResource: "RPBundle", ofType: "bundle")!) {
            if let image = UIImage(contentsOfFile: customBundle.path(forResource: "icChatbot", ofType: "tiff")!) {
                chatbotIcon.image = image
            }
        }
        chatbotIcon.contentMode = .scaleAspectFit
        opponentImageContainer.addSubview(chatbotIcon)
        self.contentView.addSubview(opponentImageContainer)
        return opponentImageContainer
    }()
    
    lazy var userImageView: UIImageView = {
        let userImageView = UIImageView()
        userImageView.isHidden = true
        userImageView.bounds.size = CGSize(width: self.minimumHeight, height: self.minimumHeight)
        let halfWidth = userImageView.bounds.width / 2.0
        let halfHeight = userImageView.bounds.height / 2.0
        
        // Center the imageview vertically to the textView when it is singleLine
        let textViewSingleLineCenter = self.textView.textContainerInset.top + (Appearance.font.lineHeight / 2.0)
        userImageView.center = CGPoint(x: self.bounds.width - halfWidth - self.padding, y: textViewSingleLineCenter)
        userImageView.backgroundColor = UIColor.lightText
        //userImageView.image = UIImage(named:"icUser_messageSent")
        if let customBundle = Bundle(path: Bundle.main.path(forResource: "RPBundle", ofType: "bundle")!) {
            if let image = UIImage(contentsOfFile: customBundle.path(forResource: "icUser_messageSent", ofType: "tiff")!) {
                userImageView.image = image
            }
        }
        userImageView.layer.rasterizationScale = UIScreen.main.scale
        userImageView.layer.shouldRasterize = true
        userImageView.layer.cornerRadius = halfHeight
        userImageView.layer.masksToBounds = true
        self.contentView.addSubview(userImageView)
        return userImageView
    }()
    
    lazy var chatAnnotationImageView: UIImageView = {
        let symbolImageView = UIImageView()
        symbolImageView.isHidden = true
        symbolImageView.bounds.size = CGSize(width: 20, height: 20)
        let halfWidth = symbolImageView.bounds.width / 2.0
        let halfHeight = symbolImageView.bounds.height / 2.0
        
        // Center the imageview vertically to the textView when it is singleLine
        let textViewSingleLineCenter = self.textView.textContainerInset.top + (Appearance.font.lineHeight / 2.0)
        symbolImageView.center = CGPoint(x: self.padding + halfWidth, y: textViewSingleLineCenter)
        symbolImageView.backgroundColor = UIColor.clear
        symbolImageView.layer.rasterizationScale = UIScreen.main.scale
        symbolImageView.layer.shouldRasterize = true
        symbolImageView.layer.cornerRadius = halfHeight
        symbolImageView.layer.masksToBounds = true
        //symbolImageView.image = UIImage(named:"icMic")
        if let customBundle = Bundle(path: Bundle.main.path(forResource: "RPBundle", ofType: "bundle")!) {
            if let image = UIImage(contentsOfFile: customBundle.path(forResource: "mic", ofType: "tiff")!) {
                symbolImageView.image = image
            }
        }
        self.messageBubbleView.addSubview(symbolImageView)
        return symbolImageView
    }()
    
    // MARK: Sizing
    
    private let padding: CGFloat = 5.0
    
    private let minimumHeight: CGFloat = 30.0 // arbitrary minimum height
    
    private var size = CGSize.zero
    
    private var cellMessageType = MessageType.text
    
    private var maxSize: CGSize {
        get {
            let maxWidth = self.bounds.width * 0.75 // Cells can take up to 3/4 of screen
            let maxHeight = CGFloat.greatestFiniteMagnitude
            return CGSize(width: maxWidth, height: maxHeight)
        }
    }
    
    func computedTextAreaHeight(message: ChatMessage) -> CGFloat {
        
        textView.text = message.content
        var cSize = textView.sizeThatFits(maxSize)
        if cSize.height < minimumHeight {
            cSize.height = minimumHeight
        }
        return cSize.height
        
    }
    
    // MARK: Setup Call
    
    func setupWithMessage(message: ChatMessage) {
        
        cellMessageType = message.messageType
        textView.text = message.content
        size = textView.sizeThatFits(maxSize)
        if size.height < minimumHeight {
            size.height = minimumHeight
        }
        textView.bounds.size = size
        if (message.sentBy == .User) {
            if (message.messageType == .voice) {
                size.width = size.width + 50
            }
        }
        messageBubbleView.bounds.size.width = size.width
        self.backgroundColor = UIColor.clear
        
        switch cellMessageType {
        case .text:
            messageBubbleView.bounds.size.height = self.contentView.bounds.size.height - 10
            break
        case .takeNotes:
            messageBubbleView.bounds.size.height = self.contentView.bounds.size.height - 10
            break
        case .noddy:
            messageBubbleView.bounds.size.height = self.contentView.bounds.size.height - 10
            break
        case .knowMore:
            messageBubbleView.bounds.size.height = size.height + 10
            break
        case .list:
            messageBubbleView.bounds.size.height = size.height + 10
            break
        case .timeSlots:
            messageBubbleView.bounds.size.height = size.height + 10
            break
        default:
            messageBubbleView.bounds.size.height = self.contentView.bounds.size.height - 10
            break
        }
        
        self.styleTextViewForSentBy(sentBy: message.sentBy)
    }
    
    // MARK: TextBubble Styling
    
    private func styleTextViewForSentBy(sentBy: SentBy) {
        let halfBubbleWidth = self.messageBubbleView.bounds.width / 2.0
        let targetX = halfBubbleWidth + padding
        let halfBubbleHeight = self.messageBubbleView.bounds.height / 2.0
        self.contentView.backgroundColor = UIColor.clear
        switch sentBy {
        case .Bot:
            self.userImageView.isHidden = true
            self.botImageView.isHidden = false
            if messageBubbleView.bounds.size.height > (minimumHeight + (2 * padding)) {
                self.botImageView.center = CGPoint(x: self.padding + (botImageView.bounds.width / 2.0), y: (messageBubbleView.bounds.size.height - (botImageView.bounds.height / 2.0)))
            }
            messageBubbleView.backgroundColor = UIColor(red: 237/255.0, green: 239/255.0, blue: 241/255.0, alpha: 1)
            textView.textColor = UIColor(red: 49/255.0, green: 63/255.0, blue: 72/255.0, alpha: 1)
            self.textView.center.x = targetX
            switch cellMessageType {
            case .text:
                self.textView.center.y = halfBubbleHeight
                break
            case .takeNotes:
                self.textView.frame.origin.y = 10
                break
            case .noddy:
                self.textView.frame.origin.y = 10
                break
            case .knowMore:
                self.textView.frame.origin.y = 5
                break
            case .list:
                self.textView.frame.origin.y = 5
                break
            case .timeSlots:
                self.textView.frame.origin.y = 5
                break
            default:
                self.textView.center.y = halfBubbleHeight
                break
            }
            self.messageBubbleView.center.x = targetX + self.botImageView.bounds.size.width + padding
            self.messageBubbleView.center.y = halfBubbleHeight
            
            break
            
            
        case .User:
            self.botImageView.isHidden = true
            self.userImageView.isHidden = false
            chatAnnotationImageView.isHidden = true
            if messageBubbleView.bounds.size.height > (minimumHeight + (2 * padding)) {
                self.userImageView.center = CGPoint(x: self.bounds.width - (userImageView.bounds.width / 2.0) - self.padding, y: (messageBubbleView.bounds.size.height - (userImageView.bounds.height / 2.0)))
            } else {
                userImageView.center.y = self.textView.textContainerInset.top + (Appearance.font.lineHeight / 2.0)
            }
            messageBubbleView.backgroundColor = UIColor(red: 68/255.0, green: 65/255.0, blue: 235/255.0, alpha: 1)
            textView.textColor = UIColor.white
            self.textView.center.x = (self.messageBubbleView.bounds.width / 2.0) + padding
            //For cell elements position
            switch cellMessageType {
            case .text:
                self.textView.center.y = self.messageBubbleView.bounds.height/2
                break
            case .voice:
                self.textView.center.y = self.messageBubbleView.bounds.height/2
                self.textView.frame.origin.x = self.chatAnnotationImageView.bounds.width + (2 * self.padding)
                chatAnnotationImageView.isHidden = false
                chatAnnotationImageView.center.y = self.messageBubbleView.bounds.height/2
                break
                
            case .takeNotes:
                self.textView.frame.origin.y = 10
                break
            case .noddy:
                self.textView.frame.origin.y = 10
                break
            default:
                self.textView.center.y = self.messageBubbleView.bounds.height/2
                break
            }
            
            self.messageBubbleView.center.x = self.bounds.width - targetX - userImageView.bounds.width - self.padding
            self.messageBubbleView.center.y = halfBubbleHeight
            
        }
    }
}

