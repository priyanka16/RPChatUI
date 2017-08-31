//
//  ContactDetailsViewController.swift
//  RPChatterBox
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import UIKit

class ContactDetailsViewController: UIViewController{
    
    var contactDetailObj = Dictionary<String, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: UITableViewDataSource

extension ContactDetailsViewController: UITableViewDataSource {
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactProfileTableViewCell", for: indexPath) as! ContactProfileTableViewCell
                cell.setupCell(contactDetail: contactDetailObj)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailTableViewCell", for: indexPath) as! ContactDetailTableViewCell
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailTableViewCell", for: indexPath) as! ContactDetailTableViewCell
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactServicesTableViewCell", for: indexPath) as! ContactServicesTableViewCell
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailTableViewCell", for: indexPath) as! ContactDetailTableViewCell
            return cell
            
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactAddressTableViewCell", for: indexPath) as! ContactAddressTableViewCell
            return cell
            
        default:
            //passing this just to solve error
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailTableViewCell", for: indexPath) as! ContactDetailTableViewCell
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ContactDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellHeight: CGFloat = 0.0

        switch indexPath.row {
        case 0:
            cellHeight = CGFloat(120)
            break
            
        case 1:
            cellHeight = CGFloat(50)
            break
            
        case 2:
            cellHeight = CGFloat(50)
            break
            
        case 3:
            cellHeight = CGFloat(150)
            break
            
        case 4:
            cellHeight = CGFloat(50)
            break
            
        case 5:
            cellHeight = CGFloat(150)
            break
            
        default:
            break
            
        }
        return CGFloat(cellHeight)
    }
}

