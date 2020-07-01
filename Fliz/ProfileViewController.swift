//
//  SecondViewController.swift
//  Fliz
//
//  Created by Andy Jiang on 1/5/19.
//  Copyright © 2019 Andy Jiang. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    

    //Connection of UI elements from storyboard to code.
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    @IBOutlet weak var averageScoreLabel: UILabel!
    
    @IBOutlet weak var fblamixHighScoreLabel: UILabel!
    @IBOutlet weak var computerHighScoreLabel: UILabel!
    @IBOutlet weak var businessHighScoreLabel: UILabel!
    @IBOutlet weak var networkHighScoreLabel: UILabel!
    @IBOutlet weak var economicsHighScoreLabel: UILabel!
    
    
    //var added = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(logout), with: nil, afterDelay: 0)
        }
        render()
        renderHighScores()  
        setup()
    
    }

    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        present((storyboard?.instantiateViewController(withIdentifier: "OnboardingViewController"))!, animated: false, completion: nil)
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: "onboardingComplete")
        userDefaults.synchronize()
        
    }
    
    func renderHighScores() {
        
        let ref = Database.database().reference(fromURL: "https://fliz-andyjiang.firebaseio.com/")
        let userID = Auth.auth().currentUser?.uid
        ref.child("fblamix-questions").child("highscores").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let highscore = value?["score"] as? String ?? ""
            self.fblamixHighScoreLabel.text = highscore
            self.businessHighScoreLabel.text = highscore
            self.networkHighScoreLabel.text = highscore
            self.economicsHighScoreLabel.text = highscore
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("computerconcepts-questions").child("highscores").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let highscore = value?["score"] as? String ?? ""
            self.computerHighScoreLabel.text = highscore
            
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("networkdesign-questions").child("highscores").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let highscore = value?["score"] as? String ?? ""
            self.networkHighScoreLabel.text = highscore
            
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("economics-questions").child("highscores").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let highscore = value?["score"] as? String ?? ""
            self.economicsHighScoreLabel.text = highscore
            
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("businesslaw-questions").child("highscores").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let highscore = value?["score"] as? String ?? ""
            self.economicsHighScoreLabel.text = highscore
            
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func render() {
        let ref = Database.database().reference(fromURL: "https://fliz-andyjiang.firebaseio.com/")
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let gamesPlayed = value?["games-played"] as? String ?? ""
            let averageScore = value?["average-score"] as? String ?? ""
            self.usernameLabel.text = username
            self.averageScoreLabel.text = averageScore
            self.gamesPlayedLabel.text = gamesPlayed 
            
        
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //Elements defined and setup of UI
    func setup() {
        
        //Profile Image
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.layer.masksToBounds = false
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        //Header view behind profile image
        headerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        headerView.layer.shadowOpacity = 0.6
        headerView.layer.shadowRadius = 3.0
        headerView.layer.shadowColor = UIColor.gray.cgColor
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "settings"), style: .done, target: self, action: #selector(settingsTapped))
        
    }
    
    @objc func settingsTapped() {
        
        presentDetail((storyboard?.instantiateViewController(withIdentifier: "SettingsNavigation"))!)
        
    }
    
}

