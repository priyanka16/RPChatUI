//
//  ChatMessage.swift
//  Chismoso
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import UIKit
import Foundation

enum MessageType : String {
    case text = "ChatMessageWithTextInput"
    case voice = "ChatMessageWithVoiceInput"
    case list = "ChatMessageWithList"
    case knowMore = "ChatMessageWithListForSearchOptions"
    case timeSlots = "ChatMessageWithTimeSlots"
    case takeNotes = "ChatMessageWithNotesOption"
    case noddy = "ChatMessageWith_YES_NO_option"
}

enum SentBy : String {
    case User = "ChatMessageSentByUser"
    case Bot = "ChatMessageSentByBot"
}

class ChatMessage : NSObject {
    
    var color : UIColor? = nil
    
    class func SentByUserString() -> String {
        return SentBy.User.rawValue
    }
    
    class func SentByBotString() -> String {
        return SentBy.Bot.rawValue
    }
    
    var sentByString: String {
        get {
            return sentBy.rawValue
        }
        set {
            if let sentBy = SentBy(rawValue: newValue) {
                self.sentBy = sentBy
            } else {
                print("ChatMessage.Error : Property Set : Incompatible string set to SentByString!")
            }
        }
    }
    
    // MARK: Public Properties
    
    var sentBy: SentBy
    var content: String
    var timeStamp: TimeInterval?
    var messageType: MessageType
    var options: [Dictionary<String, AnyObject>]?
    //var fulfillmentReply = String()
    var action = String()
    var chatContext = [NSDictionary]()
    var intent = String()
    var quickReplies = [String]()
    
    required init (content: String, sentBy: SentBy, timeStamp: TimeInterval? = nil, messageType:MessageType, listOptions: [Dictionary<String, AnyObject>]? = nil){
        self.sentBy = sentBy
        self.timeStamp = timeStamp
        self.content = content
        self.messageType = messageType
        self.options = listOptions
    }
    
    // MARK: ObjC Compatibility
    
    convenience init (content: String, sentByString: String, messageType: MessageType, listOptions: [Dictionary<String, AnyObject>]? = nil) {
        if let sentBy = SentBy(rawValue: sentByString) {
            self.init(content: content, sentBy: sentBy, timeStamp: nil, messageType: messageType, listOptions: listOptions)
        } else {
            fatalError("ChatMessage.FatalError : Initialization : Incompatible string set to SentByString!")
        }
    }
    
    convenience init (content: String, sentByString: String, timeStamp: TimeInterval, messageType: MessageType, listOptions: [Dictionary<String, AnyObject>]? = nil) {
        if let sentBy = SentBy(rawValue: sentByString) {
            self.init(content: content, sentBy: sentBy, timeStamp: timeStamp, messageType: messageType, listOptions:listOptions)
        } else {
            fatalError("ChatMessage.FatalError : Initialization : Incompatible string set to SentByString!")
        }
    }
}

