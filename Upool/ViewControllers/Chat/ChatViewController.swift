//
//  ChatViewController.swift
//  Upool
//
//  Created by Anthony Lee on 2/5/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import FirebaseFunctions

let cellId = "cellId"

class ChatViewController: UITableViewController, NVActivityIndicatorViewable {
    let db = Firestore.firestore()
    
    var messages = [Message]()
    var messagesDictionary = [String:Message]()
    var listeners = [ListenerRegistration]()
    
    private var currentUser : User? {
        return Auth.auth().currentUser
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimating(type: NVActivityIndicatorType.ballTrianglePath, color: Colors.maroon, displayTimeThreshold:2, minimumDisplayTime: 1)
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        //remove all messages
        messages.removeAll()
        messagesDictionary.removeAll()
        
        //register cell
        tableView.register(ChatUserCell.self, forCellReuseIdentifier: cellId)
        
        setupNavBar()
        observeUserMessages()
    }
    
    func setupNavBar() {
        let image: UIImage = UIImage(named: "UPoolLogo")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    func observeUserMessages(){
        for listener in listeners{
            listener.remove()
        }
        guard let id = currentUser?.uid else {return}
        
        //Get user message info from the map document
        let toUsers = db.collection(FirebaseDatabaseKeys.userMessagesKey).document(id).collection("toUserId").document("currentToUserIds")
        toUsers.getDocument(completion: { (snapshot, error) in
            guard let snapshot = snapshot, let keys = snapshot.data()?.keys else {
                print("error \(String(describing: error?.localizedDescription))")
                print("Nothing Found")
                self.stopAnimating()
                return
            }
            let userIds = Array(keys)
            
            //For each toUserId create a listener
            
            //Create a semaphore
            let group = DispatchGroup()
            
            for toUserId in userIds{
                let listener = self.db.collection(FirebaseDatabaseKeys.userMessagesKey).document(id).collection("toUserId").document(toUserId).collection("messageIds").addSnapshotListener { (snapshot, error) in
                    guard let snapshot = snapshot else {
                        print("Error fetching snapshots: \(error!)")
                        return
                    }
                    print("Snapshot : \(snapshot)")
                    
                    //listen for changes
                    snapshot.documentChanges.forEach { diff in
                        //If the data is already there, Don't retrieve it again
                        if (diff.type == .modified) {
                            print("Modified message: \(diff.document.data())")
                        } else if (diff.type == .removed) {
                            print("Removed message: \(diff.document.data())")
                        } else {
                            //start semaphore flag
                            group.enter()
                            
                            //if there are new messages, add the messages
                            let messageID = diff.document.documentID
                            self.db.collection(FirebaseDatabaseKeys.messagesKey).document(messageID).getDocument(completion: { (messageSnapShot, error) in
                                guard let messageSnapShot = messageSnapShot, let data = messageSnapShot.data() else {
                                    return
                                }
                                print("These are the observed messages :\(data)")
                                if let message = Message(dictionary: data), let id = message.chatPartnerId(){
                                    self.messages.append(message)
                                    if let mostRecentMsgTimestamp = self.messagesDictionary[id]?.timeStamp{
                                        if message.timeStamp > mostRecentMsgTimestamp{
                                            self.messagesDictionary[id] = message
                                        }
                                    } else {
                                        self.messagesDictionary[id] = message
                                    }
                                    
                                    //leave Thread
                                    group.leave()
                                }
                            })
                        }
                    }
                    //When all threads are finished, Group by user and update tableview
                    group.notify(queue: .main, execute: {
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort(by: { (m1, m2) -> Bool in
                            return m1.timeStamp > m2.timeStamp
                        })
                        print("all requests completed \(Array(self.messagesDictionary.values))")
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        self.stopAnimating()
                    })
                }
                self.listeners.append(listener)
            }
        })
    }
    
    func showChatLog(_ user:UPoolUser){
        let chatlogVC = ChatLogViewController(collectionViewLayout:UICollectionViewFlowLayout())
        chatlogVC.toUser = user
        self.navigationController?.pushViewController(chatlogVC, animated: true)
    }


}

//Table View Delegate functions

extension ChatViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages.count == 0{
            tableView.setEmptyMessage("You currently have no messages")
            return 0
        } else {
            tableView.restore()
            return messages.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatUserCell
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatlogVC = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else {return}
        
        db.collection(FirebaseDatabaseKeys.usersKey).document(chatPartnerId).getDocument { (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                let toUser = UPoolUser(dictionary: (snapshot?.data())!)
                chatlogVC.toUser = toUser
            }
            self.navigationController?.pushViewController(chatlogVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    //Edit and delete Messages
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let _ = Auth.auth().currentUser?.uid else {
            return
        }
    }
}
