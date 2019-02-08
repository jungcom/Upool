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
         let listener = db.collection("user-Messages").document((currentUser?.uid)!).collection("userMessageIds").addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }

            //listen for changes
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    print("New message: \(diff.document.data())")
                    let messageID = diff.document.documentID
                    self.db.collection("messages").document(messageID).getDocument(completion: { (messageSnapShot, error) in
                        guard let messageSnapShot = messageSnapShot, let data = messageSnapShot.data() else {
                            print("Error fetching snapshots: \(error!)")
                            return
                        }
                        print("These are the ADDED observed messages :\(data)")
                        if let message = Message(dictionary: data){
                            self.messages.append(message)
                            if let chatpartnerID = message.chatPartnerId(){
                                self.messagesDictionary[chatpartnerID] = message
                            }
                            //Group by user and update tableview at the last iteration
                            self.messages = Array(self.messagesDictionary.values)
                            self.messages.sort(by: { (m1, m2) -> Bool in
                                return m1.timeStamp > m2.timeStamp
                            })
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        }
                    })
                } else if (diff.type == .modified) {
                    print("Modified message: \(diff.document.data())")
                } else if (diff.type == .removed) {
                    print("Removed message: \(diff.document.data())")
                } else {
                    //If the data is already there, Don't retrieve it again
                    let messageID = diff.document.documentID
                    self.db.collection("messages").document(messageID).getDocument(completion: { (messageSnapShot, error) in
                        guard let messageSnapShot = messageSnapShot, let data = messageSnapShot.data() else {
                            print("Error fetching snapshots: \(error!)")
                            return
                        }
                        print("These are the observed messages :\(data)")
                        if let message = Message(dictionary: data){
                            self.messages.append(message)
                            if let chatpartnerID = message.chatPartnerId(){
                                self.messagesDictionary[chatpartnerID] = message
                            }
                            //Group by user and update tableview
                            self.messages = Array(self.messagesDictionary.values)
                            self.messages.sort(by: { (m1, m2) -> Bool in
                                return m1.timeStamp > m2.timeStamp
                            })
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
        }
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
        return 80.0
    }
}
