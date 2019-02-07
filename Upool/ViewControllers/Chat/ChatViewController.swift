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
        tableView.register(ChatUserCell.self, forCellReuseIdentifier: cellId)
        
        setupNavBar()
        observeUserMessages()
    }
    
    func observeUserMessages(){
        db.collection("user-Messages").document((currentUser?.uid)!).addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            print(Array((snapshot.data()?.keys)!))
            let messageIds = Array((snapshot.data()?.keys)!)
            for messageId in messageIds{
                self.db.collection("messages").document(messageId).getDocument(completion: { (docSnapshot, error) in
                    guard let docSnapshot = docSnapshot else {return}
                    print("\(docSnapshot.documentID) => \(docSnapshot.data())")
                    if let message = Message(dictionary: docSnapshot.data()!){
                        self.messages.append(message)
                        self.messagesDictionary[message.toId] = message
                    }
                })
            }
            
            //Group by user
            self.messages = Array(self.messagesDictionary.values)
            self.messages.sort(by: { (m1, m2) -> Bool in
                return m1.timeStamp > m2.timeStamp
            })
            self.tableView.reloadData()
                
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
        db.collection("users").document(messages[indexPath.row].toId).getDocument { (snapshot, error) in
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
