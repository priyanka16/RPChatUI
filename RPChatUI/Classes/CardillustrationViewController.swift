//
//  CardillustrationViewController.swift
//  RPChatterBox
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import UIKit

class CardillustrationViewController: UIViewController{
    
    var illustrations: [Dictionary <String, String>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib
        let customBundle = Bundle(path: Bundle.main.path(forResource: "RPBundle", ofType: "bundle")!)
        let filepath = customBundle?.path(forResource: "illustrations", ofType: "json")
        var filedata = NSData()
        do {
            try filedata = NSData(contentsOfFile: filepath!, options:NSData.ReadingOptions.mappedIfSafe)
            let parsedData = try JSONSerialization.jsonObject(with: filedata as Data, options: []) as! Dictionary <String, AnyObject>
            if let imageIllustrations = parsedData["illustrations"] as? [Dictionary<String, String>] {
                for singleIllustration in imageIllustrations {
                    illustrations.append(singleIllustration)
                }
            }
        } catch {
            abort()
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CardillustrationViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.illustrations.count;
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let demonstrationObject = self.illustrations[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardillustrationTableViewCell", for: indexPath) as! CardillustrationTableViewCell
        cell.setupCell(cardObject: demonstrationObject)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
}
