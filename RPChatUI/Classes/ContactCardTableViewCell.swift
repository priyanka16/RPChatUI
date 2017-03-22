//
//  ContactCardTableViewCell.swift
//  
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import UIKit

let contactCardWidth: CGFloat = 185
let contactCardHeight: CGFloat = 224

protocol ContactCardTableViewCellDelegate : class {
    func didTapContactCard(with contactInfo: Dictionary<String, AnyObject>)
    func didSelectContact(with contactInfo: Dictionary<String, AnyObject>)
}
//dummyContacts

class ContactCardTableViewCell : ChatMessageCell {
    
    weak var delegate: ContactCardTableViewCellDelegate?
    var options: [Dictionary<String, AnyObject>]?
    fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 8.0, bottom: 5.0, right: 8.0)
    
    //MARK: Outlets
    @IBOutlet weak var cardPageControl: UIPageControl!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    
    func setupCell(message: ChatMessage) {
        let collectionViewYconstant = super.computedTextAreaHeight(message: message)
        super.setupWithMessage(message: message)
        self.messageBubbleView.frame.origin.x = (self.botImageView.bounds.width + 10)
        collectionViewTopConstraint.constant = collectionViewYconstant
        
        //Set up dummy data
        let customBundle = Bundle(path: Bundle.main.path(forResource: "RPBundle", ofType: "bundle")!)
        let filepath = customBundle?.path(forResource: "dummyContacts", ofType: "json")
        var filedata = NSData()
        do {
            try filedata = NSData(contentsOfFile: filepath!, options:NSData.ReadingOptions.mappedIfSafe)
            let parsedData = try JSONSerialization.jsonObject(with: filedata as Data, options: []) as! Dictionary <String, AnyObject>
            if let contacts = parsedData["dummyContacts"] as? [Dictionary<String, AnyObject>] {
                setupDataSource(listOptions: contacts)
            }
        } catch {
            abort()
        }
        
        
        
    }
    
    func setupDataSource(listOptions:[Dictionary<String, AnyObject>]) {
        options = listOptions
        cardPageControl.numberOfPages = (options?.count)!
        cardPageControl.currentPage = 0
    }
}

    //MARK: UICollectionViewDataSource
extension ContactCardTableViewCell: UICollectionViewDataSource {
        
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
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactsCardCollectionViewCell",
                                                      for: indexPath) as! ContactsCardCollectionViewCell
        cell.delegate = self
        cell.setupCollectionViewCell(for: indexPath.row)
        
        if let optionCardObject = options?[indexPath.item] {
            if let contName = optionCardObject["contactName"] as? String {
                cell.contactNameLabel.text = contName
            }
            if let job = optionCardObject["contactOccupation"] as? String {
                cell.contactDesignationLabel.text = job
            }
            if let addr = optionCardObject["address"] as? String {
                cell.locationLabel.text = addr
            }
            if let dist = optionCardObject["distanceFromCurrentLocation"] as? String {
                cell.distanceLabel.text = dist
            }
            if let timings = optionCardObject["availableTimings"] as? String {
                cell.timeLabel.text = timings
            }
            if let contactId = optionCardObject["contactId"] as? Int {
                cell.selectButton.tag = contactId
            }
        }
        return cell
        
    }
}
    
extension ContactCardTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let optionCardObject = options?[indexPath.item] {
            self.delegate?.didTapContactCard(with: optionCardObject)
        }
    }
}
    
//MARK: UICollectionViewDelegateFlowLayout
extension ContactCardTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contactCardWidth, height: contactCardHeight)
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
        let newPage = floor((scrollView.contentOffset.x - contactCardWidth/2)/contactCardWidth) + 1
        self.cardPageControl.currentPage = Int(newPage)
    }
}

extension ContactCardTableViewCell: ContactsCardCollectionViewCellDelegate {
    
    func didSelectContact(with contactId: Int) {
        
        for contact in options! {
            
            if ((contact["contactId"] as! Int) == contactId) {
                self.delegate?.didSelectContact(with: contact)
            }
        }
    }
    
}

