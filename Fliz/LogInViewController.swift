//
//  LogInViewController.swift
//  FlashQuiz
//
//  Created by Andy Jiang on 1/5/19.
//  Copyright © 2019 Andy Jiang. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    //Connection of UI elements from storyboard to code.
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    //Go back function for navigation bar
    @IBAction func onBack(_ sender: Any) {
        dismissDetail()
    }
    
    //Log in function
    @IBAction func onLogIn(_ sender: Any) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            errorLabel.alpha = 1
            return
        }
        
        //Check authenication of email and password based on data from Database
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                self.errorLabel.alpha = 1
                self.errorLabel.text = error?.localizedDescription
                self.shake(viewToShake: self.errorLabel)
                return
            }
            
            //Successfully registered user's data to database
            
            self.errorLabel.alpha = 0
            self.present((self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController"))!, animated: false, completion: nil)
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "onboardingComplete")
            userDefaults.synchronize()
            
            
        }
        
    }
    
    //Elements defined and setup of UI
    func setUp() {
        emailTextField.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.5)
        passwordTextField.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.5)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.tag = 0
        passwordTextField.tag = 1
        
        errorLabel.alpha = 0
        
    }
    
    //Move down textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder, based on tag
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    //Move view down based on keyboard position
    @objc func keyboardWillShow(notification: NSNotification) {
        var translation:CGFloat = 0
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if emailTextField.isEditing{
                translation = CGFloat(-keyboardSize.height / 2.0)
            }else if passwordTextField.isEditing{
                translation = CGFloat(-keyboardSize.height / 3.8)
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.transform = CGAffineTransform(translationX: 0, y: translation)
        }
    }
    
    //Hide keyboard
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    //Shake animation for error label
    func shake(viewToShake: UITextView) {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.07
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x - 5, y: viewToShake.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x + 5, y: viewToShake.center.y))
        
        viewToShake.layer.add(shakeAnimation, forKey: "position")
        
    }
    
}
