//
//  TimeSlotTableViewCell.swift
//  
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import UIKit

let timeTabletWidth: CGFloat = 150
let timeTabletHeight: CGFloat = 50
fileprivate let itemsPerRow: CGFloat = 3

protocol TimeSlotTableViewCellDelegate : class {
    func didSelectTime()
}

class TimeSlotTableViewCell: ChatMessageCell {
    
    var timeOptions = NSDictionary()
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 9.0, right: 10.0)
    weak var delegate: TimeSlotTableViewCellDelegate?
    
    @IBOutlet weak var daysTableView: UITableView!
    @IBOutlet weak var timeslotTableView: UITableView!
    
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    
    func setupCell(message: ChatMessage) {
        let viewYconstant = super.computedTextAreaHeight(message: message)
        super.setupWithMessage(message: message)
        self.messageBubbleView.frame.origin.x = (self.botImageView.bounds.width + 10)
        containerViewTopConstraint.constant = viewYconstant + 10
        
        if let dict = message.options?[0] {
            if let timeDict = dict["availableTimeSlots"] as? NSDictionary {
                timeOptions = timeDict
            }
        }
    }
    
    func remainingDaysOfWeek() -> Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: Date())
        let weekDay = myComponents.weekday! - 1
        return 7 - weekDay
    }
    
    func dayOfWeek(day: Date) -> Int {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = calendar.components(.weekday, from: day)
        return myComponents.weekday!
    }
    
    func dayOfWeek(dayIndex: Int) -> String {
        
        let weekDay = Calendar.current.date(byAdding: .day, value: dayIndex, to: Date())
        let dateFormatter = DateFormatter()
        let daysOfWeek = dateFormatter.shortWeekdaySymbols
        let dayIndex = dayOfWeek(day: weekDay!)-1
        return (daysOfWeek?[dayIndex])!
    }
    func dayOfWeekKeyString(dayIndex: Int) -> String {
        
        let weekDay = Calendar.current.date(byAdding: .day, value: dayIndex, to: Date())
        let dateFormatter = DateFormatter()
        let daysOfWeek = dateFormatter.weekdaySymbols
        let dayIndex = dayOfWeek(day: weekDay!)-1
        return (daysOfWeek?[dayIndex])!
    }
}

extension TimeSlotTableViewCell: UITableViewDataSource {
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remainingDaysOfWeek()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == daysTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DayNameTableViewCell", for: indexPath)
            cell.textLabel?.font = UIFont(name: "SFUIText-Regular", size: 16.0)
            cell.textLabel?.textColor = UIColor(red: 49 / 255.0, green: 63 / 255.0, blue: 72 / 255.0, alpha: 1.0)
            cell.textLabel?.text = dayOfWeek(dayIndex: indexPath.row)
            cell.textLabel?.textAlignment = .right
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSlotTubeTableViewCell", for: indexPath) as! TimeSlotTubeTableViewCell
            
            let weekdayKey = dayOfWeekKeyString(dayIndex: indexPath.row).lowercased()
            if let timeSlots = timeOptions.object(forKey: weekdayKey) as? [String] {
                cell.setupCell(timeDate: timeSlots)
            }
            return cell
        }
        
    }
}
