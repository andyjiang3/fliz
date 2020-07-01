//
//  SignUpViewController.swift
//  FlashQuiz
//
//  Created by Andy Jiang on 1/5/19.
//  Copyright © 2019 Andy Jiang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class SignUpViewController: UIViewController, UITextFieldDelegate {

    //Connection of UI elements from storyboard to code.
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var errorLabel: UITextView!
    
    var textFieldRealYPosition: CGFloat = 0.0
    
    
    
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
    
    //Elements defined and setup of UI
    func setUp() {
        usernameTextField.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.5)
        emailTextField.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.5)
        passwordTextField.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.5)
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        usernameTextField.tag = 0
        emailTextField.tag = 1
        passwordTextField.tag = 2
        
        errorLabel.alpha = 0

        
    }
    
    //Actions when sign up button is clicked
    @IBAction func onSignUp(_ sender: Any) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let userName = usernameTextField.text else { return }
        

        if isValidEmail(email: email) && isValidPassword(password: password) {
            isValidUsername(username: userName) { (verified, error) in
                if error != nil {
                    return
                }
                
                guard let verified = verified else {return}
                
                if verified {
                    Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (authResult, error) in
                        if error != nil {
                            self.errorLabel.alpha = 1
                            self.errorLabel.text = error?.localizedDescription
                            self.shake(viewToShake: self.errorLabel)
                            return
                        }
                        
                        guard let user = authResult?.user else {
                            return
                        }
                        
                        
                        //Successfully Authenticated User
                        let ref = Database.database().reference(fromURL: "https://fliz-andyjiang.firebaseio.com/")
                        let usersReference = ref.child("users").child(user.uid)
                        let values = ["username": self.usernameTextField.text!, "email": self.emailTextField.text!, "games-played": "0", "average-score": "0"]
                        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                            if err != nil {
                                print(err!)
                                return
                            }
                            
                            //Successfully registered user's data to database
                            print("[SIGN UP] - Successfully Signed Up")
                            self.errorLabel.alpha = 0
                            self.present((self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController"))!, animated: false, completion: nil)
                            let userDefaults = UserDefaults.standard
                            userDefaults.set(true, forKey: "onboardingComplete")
                            userDefaults.synchronize()
                            
                        })
                        
                        //Setup highscore in Database
                         ref.child("fblamix-questions").child("highscores").child(user.uid).updateChildValues(["score": "0"])
                         ref.child("computerconcepts-questions").child("highscores").child(user.uid).updateChildValues(["score": "0"])
                        ref.child("economics-questions").child("highscores").child(user.uid).updateChildValues(["score": "0"])
                        ref.child("networkdesign-questions").child("highscores").child(user.uid).updateChildValues(["score": "0"])
                         ref.child("businesslaw-questions").child("highscores").child(user.uid).updateChildValues(["score": "0"])
                        
                    }
                } else {
                    self.errorLabel.alpha = 1
                    self.shake(viewToShake: self.errorLabel)
                    print("Password/Email/Username verification not complete!")
                }
            
            }
        } else {
            self.errorLabel.alpha = 1
            self.shake(viewToShake: self.errorLabel)
            print("Password/Email/Username verification not complete!")
        }
        
       
        
    }
    
    //MARKUP: Validations/Verifications
    
    //Email Verification (Must follow correct email format: example@gmail.com)
    func isValidEmail(email: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        var valid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
        if valid {
            valid = !email.contains("Invalid email id")
        }
        
        if valid == false {
            
            emailLabel.textColor = UIColor.red
            emailLabel.text = "EMAIL INVALID"
            emailTextField.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.red, thickness: 1.5)
            return false
            
        } else {
            
            emailTextField.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.5)
            emailLabel.textColor = UIColor.black
            emailLabel.text = "EMAIL"
            return true
            
        }
    }
    
    
    //Password Verification (Must be greater than 8 digits
    func isValidPassword(password: String) -> Bool{
        
        let passwordRegex = ".{8,}"
        var valid = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
        
        if valid {
            valid = !password.contains("Invalid password id")
        }
        
        if valid == false {
            
            passwordLabel.textColor = UIColor.red
            passwordLabel.text = "PASSWORD MUST BE AT LEAST 8 DIGITS"
            passwordTextField.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.red, thickness: 1.5)
            return false
            
        } else {
            
            passwordTextField.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.5)
            passwordLabel.textColor = UIColor.black
            passwordLabel.text = "PASSWORD"
            return true
            
        }
    }
    
    //Username Verification (Must be between 3-15 charaters w/ username not taken)
    typealias validateClosure = (Bool?, Error?) -> Void
    func isValidUsername(username: String, completion: @escaping validateClosure) {
        let usernameRegex = ".{3,15}"
        var valid = NSPredicate(format: "SELF MATCHES %@", usernameRegex).evaluate(with: username)
        
        if valid {
            valid = !username.contains("Invalid username id")
        }
        
        if valid == false {
            
            
            usernameLabel.textColor = UIColor.red
            usernameLabel.text = "USERNAME MUST BE 3-15 CHARS"
            usernameTextField.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.red, thickness: 1.5)
            
        } else {
            
            let ref = Database.database().reference(fromURL: "https://fliz-andyjiang.firebaseio.com/")
            let usernamesRef = ref.child("users")
            usernamesRef.queryOrdered(byChild: "username").queryEqual(toValue: username).observeSingleEvent(of: .value, with: { (snapshot) in
               // if there is data in the snapshot reject the registration else allow it
                
                if (snapshot.value! is NSNull) {
                    
                   
                    self.usernameTextField.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.5)
                    self.usernameLabel.textColor = UIColor.black
                    self.usernameLabel.text = "USERNAME"
                    completion(true, nil)
                    
                } else {
                    
                    self.usernameLabel.textColor = UIColor.red
                    self.usernameLabel.text = "USERNAME TAKEN"
                    self.usernameTextField.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.red, thickness: 1.5)
                    completion(false, nil)
                    
                }
                
            }) { (error) in
                completion(false, error)
                print(error.localizedDescription)
            }
            
            /* usernamesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let con = snapshot.value as! [String:[String:Any]]
                var usernamesArray = [String]()
                Array(con.keys).forEach {
                    if let res = con[$0] , let username = res["username"] as? String {
                        usernamesArray.append(username)
                    }
                }
                
                for storedUsername in usernamesArray {
                    if storedUsername == self.usernameTextField.text! {
                        self.usernameVerified = false
                        self.usernameTaken = true
                        self.usernameLabel.textColor = UIColor.red
                        self.usernameLabel.text = "USERNAME TAKEN"
                        self.usernameTextField.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.red, thickness: 1.5)
                        return
                    }
                }
                
                print("TESTT")
                self.usernameVerified = true
                print("[SIGN UP] - Username: \(self.usernameVerified)")
                self.usernameTextField.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: 1.5)
                self.usernameLabel.textColor = UIColor.black
                self.usernameLabel.text = "USERNAME"
             
                
                
            }) { (error) in
                print(error.localizedDescription)
            }
            */

            
        }
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
            if usernameTextField.isEditing{
                translation = CGFloat(-keyboardSize.height / 2.0)
            }else if emailTextField.isEditing{
                translation = CGFloat(-keyboardSize.height / 3.8)
            } else if passwordTextField.isEditing {
                translation = CGFloat(-keyboardSize.height / 4.8)
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
