//
//  ContactProfileTableViewCell.swift
//  Chismoso
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import Foundation
import UIKit

class ContactProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    func setupCell(contactDetail: Dictionary<String, AnyObject>) {
        
        if let name = contactDetail["contactName"] as? String {
            contactNameLabel.text = name
        }
    }
}
