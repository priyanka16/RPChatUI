//
//  ChatViewController.swift
//  Chismoso
//
//  Created by Priyanka
//  Copyright © 2017 __MyCompanyName__. All rights reserved.
//

import UIKit

open class ChatViewController: UIViewController {
    
    var messages: [ChatMessage] = []
    var opponentImage: UIImage?
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Private Properties
    
    fileprivate let sizingCell = ChatMessageCell()
    private let chatInput = ChatInputView(frame: CGRect.zero)
    private var bottomChatInputConstraint: NSLayoutConstraint!
    fileprivate var selectedContact: String?
    fileprivate var googleSearchString: String?
    fileprivate var selectedContactObj: Dictionary<String, AnyObject>?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        self.setUpChatInterface()
        
        //Show user a welcome message
        let newMessage = ChatMessage(content: "Hey there! I'm Po, your personal  assistant", sentBy: .Bot, messageType: .text, listOptions:nil)
        addNewMessage(message: newMessage)
    }
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listenForNotifications()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollToBottom()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterObservers()
    }
    
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
    
    func timeSlotSelected(notfObj: NSNotification) {
        
        if let selectedTime = notfObj.object as? String {
            let newMessage = ChatMessage(content: "You selected \(selectedTime).", sentBy: .Bot, messageType: .noddy, listOptions:nil)
            addNewMessage(message: newMessage)
        }
        
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Setup
    private func setUpChatInterface() {
        self.setupTableView()
        self.setupChatInput()
        self.setupLayoutConstraints()
    }
    
    private func setupTableView() {
        
        if let customBundle = Bundle.init(identifier: "org.cocoapods.RPChatUI")?.path(forResource: "RPBundle", ofType: "bundle") {
            if let imagePath: String = (customBundle.appending("/chatBackground.tiff")) {
                if let image = UIImage(contentsOfFile:imagePath) {
                    tableView.backgroundView = UIImageView(image: image)
                }
            }
        }
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.frame = self.view.bounds
        tableView.register(ChatMessageCell.classForCoder(), forCellReuseIdentifier: "TextMessageCell")
        tableView.register(NotesTableViewCell.classForCoder(), forCellReuseIdentifier: "TakeNotesMessageCell")
        tableView.register(NoddyTableViewCell.classForCoder(), forCellReuseIdentifier: "YES_NO_TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        self.view.addSubview(tableView)
    }
    
    private func setupChatInput() {
        chatInput.delegate = self
        self.view.addSubview(chatInput)
    }
    
    private func setupLayoutConstraints() {
        chatInput.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(self.chatInputConstraints())
        self.view.addConstraints(self.tableViewConstraints())
    }
    
    private func chatInputConstraints() -> [NSLayoutConstraint] {
        self.bottomChatInputConstraint = NSLayoutConstraint(item: chatInput, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: chatInput, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item: chatInput, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0)
        return [leftConstraint, self.bottomChatInputConstraint, rightConstraint]
    }
    
    private func tableViewConstraints() -> [NSLayoutConstraint] {
        let leftConstraint = NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: chatInput, attribute: .top, multiplier: 1.0, constant: 0)
        return [rightConstraint, leftConstraint, topConstraint, bottomConstraint]
    }
    
    private func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            self.chatInput.textView.resignFirstResponder()
        }
    }
    
    // MARK: Keyboard Notifications
    
    private func listenForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(timeSlotSelected(notfObj:)), name: Notification.Name("TimeSlotSelectionDidChange"), object: nil)
    }
    
    private func unregisterObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillChangeFrame(note: NSNotification) {
        let keyboardAnimationDetail = note.userInfo!
        let duration = keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        var keyboardFrame = (keyboardAnimationDetail[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if let window = self.view.window {
            keyboardFrame = window.convert(keyboardFrame, to: self.view)
        }
        let animationCurve = keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        
        self.tableView.isScrollEnabled = false
        self.tableView.decelerationRate = UIScrollViewDecelerationRateFast
        self.view.layoutIfNeeded()
        var chatInputOffset = -((self.view.bounds.height - self.bottomLayoutGuide.length) - keyboardFrame.minY)
        if chatInputOffset > 0 {
            chatInputOffset = 0
        }
        self.bottomChatInputConstraint.constant = chatInputOffset
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(rawValue: animationCurve), animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.scrollToBottom()
            }, completion: {(finished) -> () in
                self.tableView.isScrollEnabled = true
                self.tableView.decelerationRate = UIScrollViewDecelerationRateNormal
        })
    }
    
    // MARK: Rotation
    func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            self.tableView.reloadData()
        }) { (_) in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                self.scrollToBottom()
                }, completion: nil)
        }
        
    }
    
}

// MARK: UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count;
    }
    
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = self.messages[indexPath.row]
        
        switch message.messageType {
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextMessageCell", for: indexPath) as! ChatMessageCell
            cell.setupWithMessage(message: message)
            return cell
            
        case .voice:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextMessageCell", for: indexPath) as! ChatMessageCell
            cell.setupWithMessage(message: message)
            return cell
            
        case .list:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCardTableViewCell", for: indexPath) as! ContactCardTableViewCell
            cell.setupCell(message: message)
            cell.delegate = self
            return cell
            
        case .knowMore:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCardsTableViewCell", for: indexPath) as! OptionCardsTableViewCell
            cell.setupCell(message: message)
            cell.delegate = self
            return cell
            
        case .timeSlots:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSlotTableViewCell", for: indexPath) as! TimeSlotTableViewCell
            cell.setupCell(message: message)
            return cell
            
            
        case .takeNotes:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TakeNotesMessageCell", for: indexPath) as! NotesTableViewCell
            cell.setupCell(message: message)
            return cell
            
        case .noddy:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YES_NO_TableViewCell", for: indexPath) as! NoddyTableViewCell
            cell.setupCell(message: message)
            cell.delegate = self
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellHeight: CGFloat = 0.0
        let message = self.messages[indexPath.row]
        switch message.messageType {
        case .text:
            let padding: CGFloat = 10.0
            sizingCell.bounds.size.width = self.view.bounds.width
            let height = self.sizingCell.computedTextAreaHeight(message: messages[indexPath.row]) + padding;
            cellHeight = CGFloat(height)
            break
            
        case .voice:
            let padding: CGFloat = 10.0
            sizingCell.bounds.size.width = self.view.bounds.width
            let height = self.sizingCell.computedTextAreaHeight(message: messages[indexPath.row]) + padding;
            cellHeight = CGFloat(height)
            break
            
        case .list:
            let padding: CGFloat = 10.0
            let textAreaHeight = self.sizingCell.computedTextAreaHeight(message: messages[indexPath.row])
            cellHeight = CGFloat(250) + CGFloat(textAreaHeight) + (2 * padding)
            break
            
        case .knowMore:
            let textAreaHeight = self.sizingCell.computedTextAreaHeight(message: messages[indexPath.row])
            cellHeight = CGFloat(220) + CGFloat(textAreaHeight)
            break
            
        case .timeSlots:
            let padding: CGFloat = 10.0
            let textAreaHeight = self.sizingCell.computedTextAreaHeight(message: messages[indexPath.row])
            
            let numberOfRows: Int = remainingDaysOfWeek()
            let tableHeight = numberOfRows * 50
            cellHeight = CGFloat(textAreaHeight) + CGFloat(tableHeight) + (3 * padding)
            break
            
        case .takeNotes:
            let padding: CGFloat = 10.0
            let buttonHeight: CGFloat = 30
            let height = self.sizingCell.computedTextAreaHeight(message: messages[indexPath.row]) + ((3 * padding) + buttonHeight);
            cellHeight = CGFloat(height)
            break
            
        case .noddy:
            let padding: CGFloat = 10.0
            let buttonHeight: CGFloat = 30
            let height = self.sizingCell.computedTextAreaHeight(message: messages[indexPath.row]) + ((3 * padding) + buttonHeight);
            cellHeight = CGFloat(height)
            break
            
        }
        return CGFloat(cellHeight)
    }
    
    func remainingDaysOfWeek() -> Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: Date())
        let weekDay = myComponents.weekday! - 1
        return 7 - weekDay
    }
}

// MARK: ChatInputDelegate

extension ChatViewController: ChatInputDelegate {
    
    func chatInputDidResize(chatInput: ChatInputView) {
        self.scrollToBottom()
    }
    
    func chatInput(didSendMessage message: String, oftype messageType: MessageType) {
        let newUserMessage = ChatMessage(content: message, sentBy: .User, messageType: .text, listOptions:nil)
        if (messageType == .voice) {
            newUserMessage.messageType = .voice
        }
        self.addNewMessage(message: newUserMessage)
    }
    
    func attachmentButtonPressed() {
        
    }
    
    // MARK: New messages
    
    func addNewMessage(message: ChatMessage) {
        messages += [message]
        
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: (messages.count - 1), section: 0)], with: .fade)
        tableView.endUpdates()
        self.scrollToBottom()
    }
    
    // MARK: Scrolling
    
    func scrollToBottom() {
        if messages.count > 0 {
            var lastItemIdx = self.tableView.numberOfRows(inSection: 0) - 1
            if lastItemIdx < 0 {
                lastItemIdx = 0
            }
            let lastIndexPath = NSIndexPath(row: lastItemIdx, section: 0)
            self.tableView.scrollToRow(at: lastIndexPath as IndexPath, at: .bottom, animated: false)
        }
    }
    
    
}

extension ChatViewController: ContactCardTableViewCellDelegate {
    
    func didTapContactCard(with contactInfo: Dictionary<String, AnyObject>) {
        selectedContactObj = contactInfo
        self.performSegue(withIdentifier: "showContactDetailsViewController", sender: self)
    }
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showContactDetailsViewController") {
            
            if  let detailVC = segue.destination as? ContactDetailsViewController {
                if let selectedDoc = selectedContactObj {
                    detailVC.contactDetailObj = selectedDoc
                }
            }
        }
        if (segue.identifier == "showCardillustrations") {
        }
    }
    
    func didSelectContact(with contactInfo: Dictionary<String, AnyObject>) {
        
        if let contactName = contactInfo["name"] as? String {
            selectedContact = contactName
        }
    }
}

extension ChatViewController: OptionCardsTableViewCellDelegate {
    
    func didTapKnowMore(with contactInfo: Dictionary<String, AnyObject>) {
        
        if let cardName = contactInfo["cardName"] as? String {
            print(cardName)
            self.performSegue(withIdentifier: "showCardillustrations", sender: self)
        }
    }
}

extension ChatViewController: NoddyTableViewCellDelegate {
    
    func didTapYesButton() {
        let newMessage = ChatMessage(content: "You agreed!", sentBy: .Bot, messageType: .text, listOptions:nil)
        addNewMessage(message: newMessage)
        
    }
    func didTapNoButton() {
        let newMessage = ChatMessage(content: "You disagreed!", sentBy: .Bot, messageType: .text, listOptions:nil)
        addNewMessage(message: newMessage)
    }
}


