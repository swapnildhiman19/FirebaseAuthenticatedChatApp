//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!


    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            loginUser(email, password){
                error in
                if let error = error {
                    print("Login failed with error: \(error.localizedDescription)")
                } else {
                    print("Login successful")
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }

    func loginUser(_ email: String, _ password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                // User successfully logged in
                completion(nil)
            }
        }
    }
}
