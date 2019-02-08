//
//  ChatLogViewController.swift
//  Upool
//
//  Created by Anthony Lee on 2/7/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

class ChatLogViewController : UICollectionViewController{
    let db = Firestore.firestore()
    
    private var messages : [Message] = []
    
    private var fromUser : User?{
        return Auth.auth().currentUser
    }
    
    var toUser : UPoolUser?{
        didSet{
            navigationItem.title = toUser?.firstName
        }
    }
    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialUI()
        setupInputView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    @objc func handleSendMessage(){
        let message = Message()
        message.text = inputTextField.text
        message.fromId = fromUser?.uid
        message.toId = toUser?.uid
        message.timeStamp = Date()
        
        let sentMessageId = db.collection("messages").addDocument(data: message.dictionary) { (error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
        
        let userMessageRef = db.collection("user-Messages").document(message.fromId).collection("userMessageIds").document(sentMessageId.documentID)
        userMessageRef.setData([sentMessageId.documentID : 1])
        
        let receiverUserMessageRef = db.collection("user-Messages").document(message.toId).collection("userMessageIds").document(sentMessageId.documentID)
        receiverUserMessageRef.setData([sentMessageId.documentID : 1])
    }
}
