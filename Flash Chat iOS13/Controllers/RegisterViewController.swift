//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text ,let password = passwordTextfield.text {
            registerUser(email: email, password: password) { error in
                if let error = error {
                    print("Error registering user: \(error.localizedDescription)")
                } else {
                    print("User registered successfully")
                }
            }
        }
    }

    func registerUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                //succesfull registration and navigate to chat view controller
                self.performSegue(withIdentifier: K.registerSegue, sender: self)
                completion(nil)
            }
        }
    }
}
