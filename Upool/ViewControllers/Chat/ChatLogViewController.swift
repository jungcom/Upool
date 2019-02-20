//
//  ChatLogViewController.swift
//  Upool
//
//  Created by Anthony Lee on 2/7/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase


private let chatCellId = "cellID"

class ChatLogViewController : UICollectionViewController{
    let db = Firestore.firestore()
    
    private var messages = [Message]()
    
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
    
    //move input Bottom view
    var inputBottomAnchor : NSLayoutConstraint?
    
    //MARK : Input Text Views
    lazy var containerView : UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.white
        return container
    }()
    
    lazy var sendButton : UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(Colors.maroon, for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        return textField
    }()
    
    lazy var bottomSafeArea : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: chatCellId)
        
        setupInitialUI()
        setupInputView()
        retrieveUserMessages()
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
            
            //Threading handled
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
                            print("My Message : \(String(describing: message.text))")
                        }
                        group.leave()
                    })
                }
            }
            
            group.notify(queue: .main, execute: {
                self.messages.sort(by: { (m1, m2) -> Bool in
                    return m1.timeStamp < m2.timeStamp
                })
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                if let keyboardSize = self.keyboardSize{
                    self.scrollToBottom(keyboardSize.height + self.containerView.bounds.height)
                    print("scroolllll \(keyboardSize.height)")
                }
            })
        }
    }
    
    @objc func handleSendMessage(){
        guard let text = inputTextField.text, text != "" else {return}
        
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
        inputTextField.text = nil
    }
}

extension ChatLogViewController : UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: chatCellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.row]
        cell.message = message
        cell.toUser = toUser
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.text).width + 32
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 80
        if let text = messages[indexPath.row].text {
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
            self.inputBottomAnchor?.constant = -keyboardSize.height
            UIView.animate(withDuration: keyboardDuration) {
                self.view.layoutIfNeeded()
            }
            scrollToBottom(keyboardSize.height)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            self.inputBottomAnchor?.constant = 0
            UIView.animate(withDuration: keyboardDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func handleTapped(){
        view.endEditing(true)
    }
}
