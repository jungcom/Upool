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
        db.collection("messages").addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            for document in snapshot.documents {
                print("\(document.documentID) => \(document.data())")
                if let message = Message(dictionary: document.data()){
                    self.messages.append(message)
                }
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let message = messages[indexPath.row]
        cell.detailTextLabel?.text = message.text
        db.collection("users").document(message.toId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            if let toUser = UPoolUser(dictionary: snapshot.data()!){
                cell.textLabel?.text = toUser.firstName
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
