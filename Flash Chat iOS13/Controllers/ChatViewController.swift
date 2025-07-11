//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FoundationModels

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!

    let db = Firestore.firestore()

//    let messages: [Message] = [
//        Message(sender: "swapniltest1@gmail.com", body: "Hello"),
//        Message(sender: "swapniltest2@gmail.com", body: "Hi"),
//        Message(sender: "swapniltest1@gmail.com", body: "How are you?"),
//        Message(sender: "swapniltest2@gmail.com", body: "I'm fine, thanks for asking")
//    ]
    var messages: [Message] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        fetchAllMessages(): Will be called only once when the view appears
        // This is useful if you want to fetch messages only once
        // and not listen for real-time updates.
        startListeningForMessages() // This will start listening for new messages in real-time
    }

    var listener: ListenerRegistration?

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove listener to avoid memory leaks or extra updates
        listener?.remove()
    }

    func startListeningForMessages() {
        listener = db.collection(K.FStore.collectionName)
             .order(by: K.FStore.dateField) // Use this if you have a timestamp field
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                self.messages = [] // Always clear, then refill

                if let error = error {
                    print("Error listening for messages: \(error)")
                } else if let snapshot = querySnapshot {
                    for document in snapshot.documents {
                        do {
                            let message = try document.data(as: Message.self)
                            self.messages.append(message)
                        } catch {
                            print("Error decoding message: \(error)")
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if self.messages.count > 0 {
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0) //finds the last message and we are scrolling to it
                            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                        }
                    }
                }
            }
    }


    func fetchAllMessages() {
        // Clear existing messages before fetching new ones, especially important
        // if this view controller can appear multiple times.
        messages = []

        // Retrieve all the data from Firestore to show on the screen
        // Add .order(by: ...) to get messages in chronological order.
        // You'll need to add a 'timestamp' field when saving messages.
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField) // <--- Add this for sorting!
            .getDocuments { [weak self] querySnapshot, error in
            guard let self = self else { return } // Safely unwrap self

            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let querySnapshot = querySnapshot {
                    for document in querySnapshot.documents {
                        do {
                            let message = try document.data(as: Message.self)
                            self.messages.append(message)
                            print("message appended: \(message)")
                        } catch {
                            print("Error decoding snapshot document: \(error)")
                        }
                    }
                    // IMPORTANT: Reload the table view on the main thread
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        // Optional: Scroll to the bottom to show the latest messages
                        if self.messages.count > 0 {
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                        }
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }

    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let currentUserEmail = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: currentUserEmail,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: FieldValue.serverTimestamp() // Use server timestamp for accurate time
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to Firestore: \(e)")
                } else {
                    print("Successfully saved data")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = "" // Clear the text field after sending
                    }
                }
            }
        }
    }

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try logOutUser()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    func logOutUser() throws {
        try Auth.auth().signOut()
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Need to show the messages we have in the messages array
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCellTableViewCell
        if message.sender == Auth.auth().currentUser?.email {
            // This is the current user's message
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
//        cell.textLabel?.text = message.body
        cell.label.text = message.body
        return  cell
    }
}

extension ChatViewController: UITableViewDelegate {
    // This will work only if the reusable cell Selection is not .none in the storyboard
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
