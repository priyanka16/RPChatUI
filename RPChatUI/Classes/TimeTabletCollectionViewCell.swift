//
//  TimeTabletCollectionViewCell.swift
//  RPChatterBox
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import UIKit

class TimeTabletCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeTubeButton: UIButton!
    
    func setupCollectionViewCell(with timeSlot: String) {
        
        self.timeTubeButton.layer.cornerRadius = 20
        self.timeTubeButton.layer.borderWidth = 1.0
        self.timeTubeButton.layer.borderColor = UIColor(red: 68 / 255.0, green: 65 / 255.0, blue: 235 / 255.0, alpha: 1.0).cgColor
        self.timeTubeButton.layer.masksToBounds = true
        
        self.timeTubeButton.setTitle(timeSlot, for: .normal)
        self.timeTubeButton.setTitleColor(UIColor(red: 69 / 255.0, green: 65 / 255.0, blue: 234 / 255.0, alpha: 1.0), for: .normal)
    }
    @IBAction func timeTabletSelected(_ sender: AnyObject) {
        
        if (timeTubeButton.backgroundColor == UIColor.white) {
            timeTubeButton.backgroundColor = UIColor(red: 69 / 255.0, green: 65 / 255.0, blue: 234 / 255.0, alpha: 1.0)
            self.timeTubeButton.setTitleColor(UIColor.white, for: .normal)
            NotificationCenter.default.post(name: Notification.Name("TimeSlotSelectionDidChange"), object: sender.title(for: .normal))
        } else {
            timeTubeButton.backgroundColor = UIColor.white
            self.timeTubeButton.setTitleColor(UIColor(red: 69 / 255.0, green: 65 / 255.0, blue: 234 / 255.0, alpha: 1.0), for: .normal)
        }
    }
}
