//
//  BugViewController.swift
//  Fliz
//
//  Created by Andy Jiang on 2/21/19.
//  Copyright © 2019 Andy Jiang. All rights reserved.
//

import UIKit
import MessageUI
import Foundation

class BugViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    

    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var bugTextField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }

       
        
    }
    
    func setup() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "back"), style: .done, target: self, action: #selector(goBack))
        
        subjectTextField.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.5)
        bugTextField.layer.borderWidth = 1.0
        bugTextField.layer.borderColor = UIColor.black.cgColor
    }
    

    //Go back function for navigation bar
    @objc func goBack() {
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "SettingsNavigation"))!, animated: false, completion: nil)
    }
    
    //Function that is called when submit button is clicked
    @IBAction func onSubmit(_ sender: Any) {
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["andyjiang55@yahoo.com"])
        composeVC.setSubject(subjectTextField.text!)
        composeVC.setMessageBody(bugTextField.text!, isHTML: false)
        
        // Present the view controller modally.
       self.present(composeVC, animated: true, completion: nil)

        
        
    }
    
    //Dismiss email screen when email is successfully sent
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        
        controller.dismiss(animated: true)
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "SettingsNavigation"))!, animated: false, completion: nil)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
