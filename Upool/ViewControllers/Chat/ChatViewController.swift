//
//  ChatViewController.swift
//  Upool
//
//  Created by Anthony Lee on 2/5/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase

let cellId = "cellId"

class ChatViewController: UITableViewController {
    let db = Firestore.firestore()
    
    var messages = [Message]()
    var messagesDictionary = [String:Message]()
    var listeners = [ListenerRegistration]()
    
    private var currentUser : User? {
        return Auth.auth().currentUser
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        //register cell
        print("Chat did load")
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.register(ChatUserCell.self, forCellReuseIdentifier: cellId)
        setupNavBar()
        observeUserMessages()
    }
    
    func observeUserMessages(){
        guard let id = currentUser?.uid else {return}
        
        //Get user message info from the map document
        let toUsers = db.collection("user-Messages").document(id).collection("toUserId").document("currentToUserIds")
        toUsers.getDocument(completion: { (snapshot, error) in
            guard let snapshot = snapshot, let keys = snapshot.data()?.keys else {return}
            let userIds = Array(keys)
            
            //For each toUserId create a listener
            for toUserId in userIds{
                let listener = self.db.collection("user-Messages").document(id).collection("toUserId").document(toUserId).collection("messageIds").addSnapshotListener { (snapshot, error) in
                    guard let snapshot = snapshot else {
                        print("Error fetching snapshots: \(error!)")
                        return
                    }
                    print("Snapshot : \(snapshot)")
                    
                    //Create a lock/semaphore
                    let group = DispatchGroup()
                    
                    //listen for changes
                    snapshot.documentChanges.forEach { diff in
                        if (diff.type == .modified) {
                            print("Modified message: \(diff.document.data())")
                        } else if (diff.type == .removed) {
                            print("Removed message: \(diff.document.data())")
                        } else {
                            //start thread
                            group.enter()
                            
                            //If the data is already there, Don't retrieve it again
                            let messageID = diff.document.documentID
                            self.db.collection("messages").document(messageID).getDocument(completion: { (messageSnapShot, error) in
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
        return messages.count
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
        
        db.collection("users").document(chatPartnerId).getDocument { (snapshot, error) in
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
        return 100.0
    }
}
