//
//  AppDelegate.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
//        let db = Firestore.firestore()
//        saveUserData()
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistance = 50.0 // Adjust as needed

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

//    func saveUserData() {
//        // Get a reference to your Firestore database
//        let db = Firestore.firestore()
//
//        // Create some data to save. This is a simple dictionary.
//        let userData: [String: Any] = [
//            "name": "Jane Doe",
//            "email": "jane.doe@example.com",
//            "createdAt": FieldValue.serverTimestamp() // Use a server timestamp for accurate creation time
//        ]
//
//        // Add a new document to the "users" collection.
//        // Firestore will automatically generate a unique ID for this new document.
//        db.collection("users").addDocument(data: userData) { error in
//            if let error = error {
//                print("Oh no! Error adding document: \(error.localizedDescription)")
//            } else {
//                print("Hooray! Document successfully added to Firestore!")
//            }
//        }
//
//        // If you wanted to specify a document ID instead of letting Firestore generate one,
//        // you could do something like this (e.g., using a user's UID):
//        /*
//        let specificUserID = "someUserSpecificID123" // Replace with a real user ID, like from Firebase Authentication
//        db.collection("users").document(specificUserID).setData(userData) { error in
//            if let error = error {
//                print("Oh no! Error writing document with specific ID: \(error.localizedDescription)")
//            } else {
//                print("Hooray! Document with ID \(specificUserID) successfully written!")
//            }
//        }
//        */
//    }

    // You would call this function from somewhere in your app,
    // for example, when a user registers or saves their profile information.
    // saveUserData()


}

