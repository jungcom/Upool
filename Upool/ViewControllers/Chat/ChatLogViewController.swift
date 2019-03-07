//
//  ChatLogViewController.swift
//  Upool
//
//  Created by Anthony Lee on 2/7/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase


private let chatCellId = "chatCellId"
private let chatDateSectionHeaderId = "chatDateSectionHeaderId"
class ChatLogViewController : UICollectionViewController{
    let db = Firestore.firestore()
    
    private var messages = [Message]()
    private var groupedChatMessages = [[Message]]()
    private var messagesSortedKeys = [DateComponents]()
    
    private var fromUser : User?{
        return Auth.auth().currentUser
    }
    
    var toUser : UPoolUser?{
        didSet{
            navigationItem.title = toUser?.firstName
        }
    }
    
    //keyboard height
    var keyboardSize : CGRect?
    
    //to remove listeners
    var listener : ListenerRegistration?
    
    var chatLogView : ChatLogView!

    fileprivate func setupChatLogView() {
        chatLogView = ChatLogView()
        view.addSubview(chatLogView)
        chatLogView.translatesAutoresizingMaskIntoConstraints = false
        chatLogView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        chatLogView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        chatLogView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        chatLogView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        chatLogView.sendButton.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Register Cells
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: chatCellId)
        collectionView.register(ChatDateSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: chatDateSectionHeaderId)
        
        setupInitialUI()
        setupChatLogView()
        retrieveUserMessages()
    }
    
    func setupInitialUI(){
        //keyboard setup
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapped))
        view.addGestureRecognizer(tap)
        
        collectionView.backgroundColor = UIColor.groupTableViewBackground
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 80, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
        NotificationCenter.default.removeObserver(self)
        if let listener = listener{
            listener.remove()
        }
    }
    
    func retrieveUserMessages(){
        guard let id = fromUser?.uid, let toUser = toUser else {return}
        listener = db.collection("user-Messages").document(id).collection("toUserId").document(toUser.uid).collection("messageIds").addSnapshotListener{ (snapshot, error) in
            guard let snapshot = snapshot else {return}
            
            //Multi-Threading handled
            let group = DispatchGroup()
            
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .modified) {
                    print("Modified message: \(diff.document.data())")
                } else if (diff.type == .removed) {
                    print("Removed message: \(diff.document.data())")
                } else {
                    group.enter()
                    //If the data is already there, Don't retrieve it again
                    self.db.collection("messages").document(diff.document.documentID).getDocument(completion: { (docSnapshot, error) in
                        guard let docSnapshot = docSnapshot, let data = docSnapshot.data() else {return}
                        if let message = Message(dictionary: data){
                            self.messages.append(message)
                            //print("My Message : \(String(describing: message.text))")
                        }
                        group.leave()
                    })
                }
            }
            
            //When all network requests are completed
            group.notify(queue: .main, execute: {
                self.messages.sort(by: { (m1, m2) -> Bool in
                    return m1.timeStamp < m2.timeStamp
                })
                //Create section for creating different
                self.createMessageDictionary()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    //  MARK: TODO: The Section should be dynamic
                    //  Scroll to Bottom of the chat
                    if let last = self.groupedChatMessages.last{
                        let lastItemIndex = NSIndexPath(item: last.count - 1, section: self.groupedChatMessages.count - 1)
                        self.collectionView.scrollToItem(at: lastItemIndex as IndexPath, at: .bottom, animated: true)
                    }
                }

                if let keyboardSize = self.keyboardSize{
                    self.scrollToBottom(keyboardSize.height + self.chatLogView.containerView.bounds.height)
                }
            })
        }
    }
    
    func createMessageDictionary(){
        let groupDic = Dictionary(grouping: messages) { (message) -> DateComponents in
            let date = Calendar.current.dateComponents([.day, .year, .month, .weekday], from: (message.timeStamp)!)
            return date
        }
        // Sort the keys
        let sortedKeys = groupDic.keys.sorted { (date1, date2) -> Bool in
            if date1.year! != date2.year!{
                return date1.year! < date2.year!
            } else if date1.month! != date2.month!{
                return date1.month! < date2.month!
            } else {
                return date1.day! < date2.day!
            }
        }
        messagesSortedKeys = sortedKeys
        
        //Remove all groupedChatMessages and create a new one
        groupedChatMessages.removeAll()
        sortedKeys.forEach { (key) in
            let values = groupDic[key]
            groupedChatMessages.append(values ?? [])
        }
    }
    
    @objc func handleSendMessage(){
        guard let text = chatLogView.inputTextField.text, text != "" else {return}
        
        let message = Message()
        message.text = text
        message.fromId = fromUser?.uid
        message.toId = toUser?.uid
        message.timeStamp = Date()
        
        let sentMessageId = db.collection("messages").addDocument(data: message.dictionary) { (error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
        
        let userMessageRef = db.collection("user-Messages").document(message.fromId).collection("toUserId").document(message.toId).collection("messageIds").document(sentMessageId.documentID)
        userMessageRef.setData([sentMessageId.documentID : 1])
        let userMapRefForSubcollection = db.collection("user-Messages").document(message.fromId).collection("toUserId").document("currentToUserIds")
        userMapRefForSubcollection.setData([message.toId : 1], merge: true)
        
        let receiverUserMessageRef = db.collection("user-Messages").document(message.toId).collection("toUserId").document(message.fromId).collection("messageIds").document(sentMessageId.documentID)
        receiverUserMessageRef.setData([sentMessageId.documentID : 1])
        let receiverMapRefForSubcollection = db.collection("user-Messages").document(message.toId).collection("toUserId").document("currentToUserIds")
        receiverMapRefForSubcollection.setData([message.fromId : 1], merge: true)
        
        //Clear Input + Scroll To Bottom
        chatLogView.inputTextField.text = nil
    }
}

extension ChatLogViewController : UICollectionViewDelegateFlowLayout{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupedChatMessages[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: chatCellId, for: indexPath) as! ChatMessageCell
        let message = groupedChatMessages[indexPath.section][indexPath.row]
        cell.message = message
        cell.toUser = toUser
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text).width + 32
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 80
        if let text = groupedChatMessages[indexPath.section][indexPath.row].text {
            height = estimateFrameForText(text : text).height + 20
        }
        
        return CGSize(width: self.view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text : String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font : UIFont(name: Fonts.helvetica, size: 16)!] as [NSAttributedString.Key : Any]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    //Date Section headers
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return messagesSortedKeys.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: chatDateSectionHeaderId, for: indexPath) as! ChatDateSectionHeader
        header.date = messagesSortedKeys[indexPath.section]
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70)
    }
}

extension ChatLogViewController {
    //Textfield Notifications
    func setupKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func scrollToBottom(_ keyboardHeight: CGFloat) {
        //Scroll to bottom of message
        let bottomOffset = CGPoint(x: 0, y: collectionView.contentSize.height - collectionView.bounds.size.height + collectionView.contentInset.bottom + keyboardHeight)
        collectionView.setContentOffset(bottomOffset, animated: true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            print("notification: Chat Keyboard will show")
            self.keyboardSize = keyboardSize
            self.chatLogView.inputBottomAnchor?.constant = -keyboardSize.height
            UIView.animate(withDuration: keyboardDuration) {
                self.view.layoutIfNeeded()
            }
            scrollToBottom(keyboardSize.height)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            self.chatLogView.inputBottomAnchor?.constant = 0
            UIView.animate(withDuration: keyboardDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func handleTapped(){
        view.endEditing(true)
    }
}
