//
//  OptionCardsTableViewCell.swift
//  
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import UIKit

let optionCardWidth: CGFloat = 200
let optionCardHeight: CGFloat = 175

protocol OptionCardsTableViewCellDelegate : class {
    func didTapKnowMore(with contactInfo: Dictionary<String, AnyObject>)
}


class OptionCardsTableViewCell : ChatMessageCell {
    
    var options: [Dictionary<String, AnyObject>]?
    fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 8.0, bottom: 5.0, right: 8.0)
    weak var delegate: OptionCardsTableViewCellDelegate?
    
    //MARK: Outlets
    @IBOutlet weak var cardPageControl: UIPageControl!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    
    func setupCell(message: ChatMessage) {
        let collectionViewYconstant = super.computedTextAreaHeight(message: message)
        super.setupWithMessage(message: message)
        self.messageBubbleView.frame.origin.x = (self.botImageView.bounds.width + 10)
        collectionViewTopConstraint.constant = collectionViewYconstant //20 is for padding including the message bubble padding + spacing for the collection view
        
        //Set up dummy data
        if let customBundle = Bundle.init(identifier: "org.cocoapods.RPChatUI")?.path(forResource: "RPBundle", ofType: "bundle") {
            if let filepath: String = (customBundle.appending("/cards.json")) {
                var filedata = NSData()
                do {
                    try filedata = NSData(contentsOfFile: filepath, options:NSData.ReadingOptions.mappedIfSafe)
                    let parsedData = try JSONSerialization.jsonObject(with: filedata as Data, options: []) as! Dictionary <String, AnyObject>
                    if let contacts = parsedData["cards"] as? [Dictionary<String, AnyObject>] {
                        setupDataSource(listOptions: contacts)
                    }
                } catch {
                    abort()
                }
            }
        }
    }
    
    func setupDataSource(listOptions:[Dictionary<String, AnyObject>]) {
        options = listOptions
        cardPageControl.numberOfPages = (options?.count)!
        cardPageControl.currentPage = 0
    }
}

//MARK: UICollectionViewDataSource
extension OptionCardsTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        if (options != nil) {
            return options!.count
        } else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCardCollectionViewCell",
                                                      for: indexPath) as! OptionCardCollectionViewCell
        cell.setupCollectionViewCell(for: indexPath.row)
        if let optionCardObject = options?[indexPath.item] {
            if let cardTitle = optionCardObject["cardName"] {
                cell.cardTitleLabel.text = cardTitle as? String
            }
        }
        return cell
        
    }
}

extension OptionCardsTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let optionCardObject = options?[indexPath.item] {
            self.delegate?.didTapKnowMore(with: optionCardObject)
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension OptionCardsTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: optionCardWidth, height: optionCardHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newPage = floor((scrollView.contentOffset.x - optionCardWidth/2)/optionCardWidth) + 1
        self.cardPageControl.currentPage = Int(newPage)
        
    }
}

