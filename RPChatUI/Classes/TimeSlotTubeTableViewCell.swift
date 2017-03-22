//
//  TimeSlotTubeTableViewCell.swift
//  RPChatterBox
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import UIKit

let tabletWidth: CGFloat = 150
let tabletHeight: CGFloat = 40

class TimeSlotTubeTableViewCell: UITableViewCell {
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
    var timeSlots: [String]?
    
    func setupCell(timeDate: [String]) {
        timeSlots = timeDate
    }
}

//MARK: UICollectionViewDataSource
extension TimeSlotTubeTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        if (timeSlots != nil) {
            return timeSlots!.count
        } else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeTabletCollectionViewCell",
                                                      for: indexPath) as! TimeTabletCollectionViewCell
        if let timeData = timeSlots?[indexPath.row] {
            cell.setupCollectionViewCell(with: timeData)
        } 
        return cell
    }
}

extension TimeSlotTubeTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension TimeSlotTubeTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: tabletWidth, height: tabletHeight)
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
}



