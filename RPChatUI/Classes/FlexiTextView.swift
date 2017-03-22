//
//  FlexiTextView.swift
//  RPChatterBox
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import Foundation
import UIKit

@objc protocol FlexiTextViewDelegate {
    func stretchyTextViewDidChangeSize(chatInput: FlexiTextView)
    func stretchyTextViewDidChange(chatInput: FlexiTextView)
    @objc optional func stretchyTextView(textView: FlexiTextView, validityDidChange isValid: Bool)
}

class FlexiTextView : UITextView, UITextViewDelegate {
    
    weak var flexiTextViewDelegate: FlexiTextViewDelegate?
    
    // MARK: Public Properties
    
    var maxHeightPortrait: CGFloat = 160
    var maxHeightLandScape: CGFloat = 60
    var maxHeight: CGFloat {
        get {
            return UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation) ? maxHeightPortrait : maxHeightLandScape
        }
    }
    // MARK: Private Properties
    
    private var maxSize: CGSize {
        get {
            return CGSize(width: self.bounds.width, height: self.maxHeightPortrait)
        }
    }
    
    private var isValid: Bool = false {
        didSet {
            if isValid != oldValue {
                flexiTextViewDelegate?.stretchyTextView?(textView: self, validityDidChange: isValid)
            }
        }
    }
    
    private let sizingTextView = UITextView()
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder!
            placeholderLabel.isHidden = !(text.characters.count == 0)
        }
    }
    
    var placeholderLabel = UILabel()
    var previousRect = CGRect.zero
    
    // MARK: Property Overrides
    
    override var contentSize: CGSize {
        didSet {
            resize()
        }
    }

    override var font: UIFont! {
        didSet {
            sizingTextView.font = font
        }
    }
    
    override var textContainerInset: UIEdgeInsets {
        didSet {
            sizingTextView.textContainerInset = textContainerInset
        }
    }
    
    // MARK: Initializers
    
    override init(frame: CGRect = CGRect.zero, textContainer: NSTextContainer? = nil) {
        super.init(frame: frame, textContainer: textContainer);
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    func setup() {
        font = UIFont(name: "SFUIText-Light", size: 17.0)
        textContainerInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        delegate = self
        
        //For Placeholder
        placeholderLabel.frame = self.textInputView.frame 
        placeholderLabel.textColor = UIColor(red: 195/255.0, green: 205/255.0, blue: 212/255.0, alpha: 1)
        placeholderLabel.font = font
        self.addSubview(placeholderLabel)
        
        if let _ = placeholder {
            placeholderLabel.text = placeholder!
            placeholderLabel.isHidden = false
        }
        else {
            placeholderLabel.isHidden = true
        }

    }
    
    // MARK: Sizing
    
    func resize() {
        /*if (self.text.characters.count == 0) {
            bounds.size.height = self.targetHeight() + 10
        } else {
            bounds.size.height = self.targetHeight()
        }*/
        bounds.size.height = self.targetHeight() + 10
        placeholderLabel.frame = self.textInputView.frame
        flexiTextViewDelegate?.stretchyTextViewDidChangeSize(chatInput: self)
    }
    
    func targetHeight() -> CGFloat {
        
        sizingTextView.text = self.text
        let targetSize = sizingTextView.sizeThatFits(maxSize)
        let targetHeight = targetSize.height
        let maxHeight = self.maxHeight
        return targetHeight < maxHeight ? targetHeight : maxHeight
    }
    
    // MARK: Alignment
    
    func align() {
        guard let end = self.selectedTextRange?.end, let caretRect: CGRect = self.caretRect(for:end) else { return }
        
        let topOfLine = caretRect.minY
        let bottomOfLine = caretRect.maxY
        
        let contentOffsetTop = self.contentOffset.y
        let bottomOfVisibleTextArea = contentOffsetTop + self.bounds.height
        
        let caretHeightPlusInsets = caretRect.height + self.textContainerInset.top + self.textContainerInset.bottom
        if caretHeightPlusInsets < self.bounds.height {
            var overflow: CGFloat = 0.0
            if topOfLine < contentOffsetTop + self.textContainerInset.top {
                overflow = topOfLine - contentOffsetTop - self.textContainerInset.top
            } else if bottomOfLine > bottomOfVisibleTextArea - self.textContainerInset.bottom {
                overflow = (bottomOfLine - bottomOfVisibleTextArea) + self.textContainerInset.bottom
            }
            self.contentOffset.y += overflow
        }
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        self.align()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.isValid = textView.text.characters.count > 0
        flexiTextViewDelegate?.stretchyTextViewDidChange(chatInput: textView as! FlexiTextView)
        
        if (self.placeholder != nil) {
            self.placeholderLabel.isHidden = !(self.text.characters.count == 0)
        }
        else {
            self.placeholderLabel.isHidden = true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeholderLabel.isHidden = true
    }

}

