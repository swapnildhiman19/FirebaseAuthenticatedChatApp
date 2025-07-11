//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!

    func typerTextAnimation(_ text: String, in label: UILabel, characterDelay: Double = 0.1) {
        label.text = "" // Clear the label before starting the animation
        for (letterIndex, letter) in text.enumerated() {
            // Want to show the Typing animation for each letter, for loop executes really fast, thus we are scheduling each letter with a delay here 
            DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(letterIndex)) {
                label.text?.append(letter)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.text = ""
        let text = "⚡FlashChat"
        titleLabel.text = text // will automatically trigger the animation
        titleLabel.charInterval = 0.1 // Set the interval for each character to appear
        /*
        var currentIndex = 0.0
        for letter in text {
            // Want to show the Typing animation for each letter
            Timer.scheduledTimer(withTimeInterval: 0.1 * currentIndex, repeats: false) { timer in
                DispatchQueue.main.async {
                    self.titleLabel.text?.append(letter)
                }
            }
            currentIndex += 1.0
            print(currentIndex)
        }
         */
//        typerTextAnimation(text, in: titleLabel, characterDelay: 0.08)
    }
}
