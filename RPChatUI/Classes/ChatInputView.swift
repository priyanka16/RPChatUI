//
//  ChatInputView.swift
//  Chismoso
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import Foundation
import UIKit


protocol ChatInputDelegate : class {
    func chatInputDidResize(chatInput: ChatInputView)
    func chatInput(didSendMessage message: String, oftype messageType: MessageType)
    //func chatInput(didAttach images: UIImage)
    func attachmentButtonPressed()
}

class ChatInputView : UIView, FlexiTextViewDelegate {
    
    // MARK: Styling
    
    struct Appearance {
        static var includeBlur = false
        static var tintColor = UIColor(red: 0.0, green: 120 / 255.0, blue: 255 / 255.0, alpha: 1.0)
        static var backgroundColor = UIColor.white
        static var textViewFont = UIFont(name: "SFUIText-Light", size: 16.0)
        static var textViewTextColor = UIColor.darkText
        static var textViewBackgroundColor = UIColor(red: 228 / 255.0, green: 233 / 255.0, blue: 236 / 255.0, alpha: 1.0)
    }
    
    // MARK: Public Properties
    
    var textViewInsets = UIEdgeInsets(top: 5, left: 20, bottom: 8, right: 5)
    weak var delegate: ChatInputDelegate?
    var isListening: Bool?
    
    
    // MARK: Private Properties
    
    let textView = FlexiTextView(frame: CGRect.zero, textContainer: nil)
    private let sendButton = UIButton(type: .custom)
    private let attachmentButton = UIButton(type: .custom)
    private let stopListeningButton = UIButton(type: .custom)
    private let blurredBackgroundView: UIToolbar = UIToolbar()
    private var heightConstraint: NSLayoutConstraint!
    private var sendButtonHeightConstraint: NSLayoutConstraint!
    
    // MARK: Initialization
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        self.setup()
        self.stylize()
        
        NotificationCenter.default.addObserver(self, selector: #selector(transactionDidReceiveRecognition), name: Notification.Name("SKTransactionDidReceiveRecognition"), object: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        isListening = false
        self.setupSendButton()
        self.setupSendButtonConstraints()
        
        self.setupAttachmentButton()
        self.setupAttachmentButtonConstraints()
        
        self.setupTextView()
        self.setupTextViewConstraints()
        self.setupBlurredBackgroundView()
        self.setupBlurredBackgroundViewConstraints()
    }
    
    func setupTextView() {
        textView.bounds = UIEdgeInsetsInsetRect(self.bounds, self.textViewInsets)
        textView.flexiTextViewDelegate = self
        textView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        self.styleTextView()
        self.textView.placeholder = NSLocalizedString("Type Something...", comment: "")
        self.addSubview(textView)
    }
    
    func styleTextView() {
        textView.layer.rasterizationScale = UIScreen.main.scale
        textView.layer.shouldRasterize = true
    }
    
    func setupSendButton() {
        
        if let customBundle = Bundle.init(identifier: "org.cocoapods.RPChatUI")?.path(forResource: "RPBundle", ofType: "bundle") {
            if let imagePath: String = (customBundle.appending("/mic.tiff")) {
                if let micImage = UIImage(contentsOfFile:imagePath) {
                    self.sendButton.setImage(micImage, for: .normal)
                }
            }
        }
        self.sendButton.tag = 100
        self.sendButton.addTarget(self, action: #selector(sendButtonPressed(sender:)), for: .touchUpInside)
        self.sendButton.bounds = CGRect(x: 0, y: 0, width: 40, height: 1)
        self.addSubview(sendButton)
    }
    
    func setupAttachmentButton() {
        if let customBundle = Bundle.init(identifier: "org.cocoapods.RPChatUI")?.path(forResource: "RPBundle", ofType: "bundle") {
            if let imagePath: String = (customBundle.appending("/icAttachment.tiff")) {
                if let micImage = UIImage(contentsOfFile:imagePath) {
                    self.attachmentButton.setImage(micImage, for: .normal)
                }
            }
        }
        self.attachmentButton.addTarget(self, action: #selector(attachmentButtonPressed(sender:)), for: .touchUpInside)
        self.attachmentButton.bounds = CGRect(x: 0, y: 0, width: 40, height: 1)
        self.addSubview(attachmentButton)
    }
    
    func setupStopListeningButton() {
        if let customBundle = Bundle.init(identifier: "org.cocoapods.RPChatUI")?.path(forResource: "RPBundle", ofType: "bundle") {
            if let imagePath: String = (customBundle.appending("/icClose.tiff")) {
                if let image = UIImage(contentsOfFile:imagePath) {
                    self.stopListeningButton.setImage(image, for: .normal)
                }
            }
        }
        self.stopListeningButton.addTarget(self, action: #selector(closeButtonPressed(sender:)), for: .touchUpInside)
        self.stopListeningButton.bounds = CGRect(x: 0, y: 0, width: 30, height: 1)
        self.addSubview(stopListeningButton)
    }
    
    
    func setupListening() {
        
        self.attachmentButton.removeFromSuperview()
        if let customBundle = Bundle.init(identifier: "org.cocoapods.RPChatUI")?.path(forResource: "RPBundle", ofType: "bundle") {
            if let imagePath: String = (customBundle.appending("/sound-wave.tiff")) {
                if let image = UIImage(contentsOfFile:imagePath) {
                    self.sendButton.setImage(image, for: .normal)
                }
            }
        }
        self.sendButton.tag = 1010
        self.sendButton.layer.borderColor = UIColor.clear.cgColor
        self.setupTextViewConstraintsInListeningMode()
        self.setupSendButtonConstraintsInMicMode()
        self.setupStopListeningButton()
        self.setupStopListeningButtonConstraints()
    }
    
    func setupSendButtonConstraints() {
        self.sendButton.translatesAutoresizingMaskIntoConstraints = false
        self.sendButton.removeConstraints(self.sendButton.constraints)
        
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: self.sendButton, attribute: .right, multiplier: 1.0, constant: 40)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.sendButton, attribute: .bottom, multiplier: 1.0, constant: textViewInsets.bottom)
        let widthConstraint = NSLayoutConstraint(item: self.sendButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        sendButtonHeightConstraint = NSLayoutConstraint(item: self.sendButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        self.addConstraints([sendButtonHeightConstraint, widthConstraint, rightConstraint, bottomConstraint])
    }
    
    func setupSendButtonConstraintsInMicMode() {
        self.sendButton.translatesAutoresizingMaskIntoConstraints = false
        self.sendButton.removeConstraints(self.sendButton.constraints)
        
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: self.sendButton, attribute: .right, multiplier: 1.0, constant: textViewInsets.right)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.sendButton, attribute: .bottom, multiplier: 1.0, constant: textViewInsets.bottom)
        let widthConstraint = NSLayoutConstraint(item: self.sendButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        sendButtonHeightConstraint = NSLayoutConstraint(item: self.sendButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        self.addConstraints([sendButtonHeightConstraint, widthConstraint, rightConstraint, bottomConstraint])
    }
    
    
    func setupStopListeningButtonConstraints() {
        self.stopListeningButton.translatesAutoresizingMaskIntoConstraints = false
        self.stopListeningButton.removeConstraints(self.stopListeningButton.constraints)
        
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: self.stopListeningButton, attribute: .left, multiplier: 1, constant: -10)
        let centerConstraint = NSLayoutConstraint(item: self.textView, attribute: .centerY, relatedBy: .equal, toItem: self.stopListeningButton, attribute: .centerY, multiplier: 1.0, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: self.stopListeningButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25)
        let hieghtConstraint = NSLayoutConstraint(item: self.stopListeningButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25)
        self.addConstraints([hieghtConstraint, widthConstraint, leftConstraint, centerConstraint])
    }
    
    func setupAttachmentButtonConstraints() {
        self.attachmentButton.translatesAutoresizingMaskIntoConstraints = false
        self.attachmentButton.removeConstraints(self.attachmentButton.constraints)
        
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: self.attachmentButton, attribute: .right, multiplier: 1.0, constant: textViewInsets.right)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.attachmentButton, attribute: .bottom, multiplier: 1.0, constant: textViewInsets.bottom)
        let widthConstraint = NSLayoutConstraint(item: self.attachmentButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        sendButtonHeightConstraint = NSLayoutConstraint(item: self.attachmentButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        self.addConstraints([sendButtonHeightConstraint, widthConstraint, rightConstraint, bottomConstraint])
    }
    
    func setupTextViewConstraints() {
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.textView.removeConstraints(self.textView.constraints)
        
        let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.textView, attribute: .top, multiplier: 1.0, constant: -textViewInsets.top)
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: self.textView, attribute: .left, multiplier: 1, constant: -textViewInsets.left)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.textView, attribute: .bottom, multiplier: 1, constant: textViewInsets.bottom)
        let rightConstraint = NSLayoutConstraint(item: self.textView, attribute: .right, relatedBy: .equal, toItem: self.sendButton, attribute: .left, multiplier: 1, constant: -textViewInsets.right)
        heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.00, constant: 40)
        self.addConstraints([topConstraint, leftConstraint, bottomConstraint, rightConstraint, heightConstraint])
    }
    
    func setupTextViewConstraintsInListeningMode() {
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.textView, attribute: .top, multiplier: 1.0, constant: -textViewInsets.top)
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: self.textView, attribute: .left, multiplier: 1, constant: -36)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.textView, attribute: .bottom, multiplier: 1, constant: textViewInsets.bottom)
        let rightConstraint = NSLayoutConstraint(item: self.textView, attribute: .right, relatedBy: .equal, toItem: self.sendButton, attribute: .left, multiplier: 1, constant: -textViewInsets.right)
        heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.00, constant: 40)
        self.addConstraints([topConstraint, leftConstraint, bottomConstraint, rightConstraint, heightConstraint])
    }
    
    func setupBlurredBackgroundView() {
        self.addSubview(self.blurredBackgroundView)
        self.sendSubview(toBack: self.blurredBackgroundView)
    }
    
    func setupBlurredBackgroundViewConstraints() {
        self.blurredBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.blurredBackgroundView, attribute: .top, multiplier: 1.0, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: self.blurredBackgroundView, attribute: .left, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.blurredBackgroundView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: self.blurredBackgroundView, attribute: .right, multiplier: 1.0, constant: 0)
        self.addConstraints([topConstraint, leftConstraint, bottomConstraint, rightConstraint])
    }
    
    // MARK: Styling
    
    func stylize() {
        self.textView.backgroundColor = Appearance.textViewBackgroundColor
        self.textView.font = Appearance.textViewFont
        self.textView.textColor = Appearance.textViewTextColor
        self.blurredBackgroundView.isHidden = !Appearance.includeBlur
        self.backgroundColor = UIColor(red: 228 / 255.0, green: 233 / 255.0, blue: 236 / 255.0, alpha: 1.0)
    }
    
    // MARK: StretchyTextViewDelegate
    
    func stretchyTextViewDidChangeSize(chatInput textView: FlexiTextView) {
        let textViewHeight = textView.bounds.height
        if textView.text.characters.count == 0 {
            self.sendButtonHeightConstraint.constant = textViewHeight
        }
        let targetConstant = textViewHeight + textViewInsets.top + textViewInsets.bottom
        self.heightConstraint.constant = targetConstant
        self.delegate?.chatInputDidResize(chatInput: self)
    }
    
    func stretchyTextView(textView: FlexiTextView, validityDidChange isValid: Bool) {
        
    }
    
    func stretchyTextViewDidChange(chatInput: FlexiTextView) {
        if (chatInput.text.characters.count > 0) {
            if let customBundle = Bundle.init(identifier: "org.cocoapods.RPChatUI")?.path(forResource: "RPBundle", ofType: "bundle") {
                if let imagePath: String = (customBundle.appending("/icSend.tiff")) {
                    if let image = UIImage(contentsOfFile:imagePath) {
                        self.sendButton.setImage(image, for: .normal)
                    }
                }
            }
            
            self.sendButton.tag = 500
        } else {
            if let customBundle = Bundle.init(identifier: "org.cocoapods.RPChatUI")?.path(forResource: "RPBundle", ofType: "bundle") {
                if let imagePath: String = (customBundle.appending("/mic.tiff")) {
                    if let image = UIImage(contentsOfFile:imagePath) {
                        self.sendButton.setImage(image, for: .normal)
                    }
                }
            }
            self.sendButton.tag = 100
        }
    }
    
    // MARK: Button Presses
    
    func sendButtonPressed(sender: UIButton) {
        if (sender.tag == 100) {
            self.setupListening()
            self.textView.text = ""
            self.textView.placeholder = NSLocalizedString("Listening...", comment: "")
            isListening = true
        } else {
            if self.textView.text.characters.count > 0 {
                if (isListening)! {
                    self.delegate?.chatInput(didSendMessage: self.textView.text, oftype: .voice)
                } else {
                    self.delegate?.chatInput(didSendMessage: self.textView.text, oftype: .text)
                }
                self.textView.text = ""
                self.textView.placeholder = NSLocalizedString("Type Something...", comment: "")
                if let customBundle = Bundle.init(identifier: "org.cocoapods.RPChatUI")?.path(forResource: "RPBundle", ofType: "bundle") {
                    if let imagePath: String = (customBundle.appending("/mic.tiff")) {
                        if let image = UIImage(contentsOfFile:imagePath) {
                            self.sendButton.setImage(image, for: .normal)
                        }
                    }
                }
                self.sendButton.tag = 100
                isListening = false
            }
        }
    }
    
    func attachmentButtonPressed(sender: UIButton) {
        self.delegate?.attachmentButtonPressed()
    }
    
    func closeButtonPressed(sender: UIButton) {
        
        self.stopListeningButton.removeFromSuperview()
        self.sendButton.removeFromSuperview()
        self.textView.removeFromSuperview()
        self.setup()
    }
    
    // MARK: Notification Handler
    func transactionDidReceiveRecognition(withNotification notification : NSNotification) {
        if let notfObj = notification.object as? Dictionary<String, AnyObject> {
            if let message = notfObj["RecognitionText"] as? String {
                OperationQueue.main.addOperation({
                    self.textView.placeholderLabel.isHidden = true
                    self.textView.text = message
                    self.sendButton.tag = 500
                    self.sendButtonPressed(sender: self.sendButton)
                    self.closeButtonPressed(sender: self.stopListeningButton)
                    
                    
                })
            }
        }
    }
}
