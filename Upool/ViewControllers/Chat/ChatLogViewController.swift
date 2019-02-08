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
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: chatCellId)
        
        setupInitialUI()
        setupInputView()
        retrieveUserMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    func retrieveUserMessages(){
        guard let id = fromUser?.uid else {return}
        let listener = db.collection("user-Messages").document(id).collection("userMessageIds").addSnapshotListener{ (snapshot, error) in
            guard let snapshot = snapshot else {return}
            
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .modified) {
                    print("Modified message: \(diff.document.data())")
                } else if (diff.type == .removed) {
                    print("Removed message: \(diff.document.data())")
                } else {
                    //If the data is already there, Don't retrieve it again
                    self.db.collection("messages").document(diff.document.documentID).getDocument(completion: { (docSnapshot, error) in
                        guard let docSnapshot = docSnapshot, let data = docSnapshot.data() else {return}
                        if let message = Message(dictionary: data){
                            if message.fromId == self.fromUser?.uid{
                                self.messages.append(message)
                                print("My Message : \(message)")
                            }
                        }
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    })
                }
            }
        }
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

extension ChatLogViewController : UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: chatCellId, for: indexPath) as! ChatMessageCell
        cell.message = messages[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}
