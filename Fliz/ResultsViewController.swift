//
//  BorderExtension.swift
//  Fliz
//
//  Created by Andy Jiang on 1/5/19.
//  Copyright © 2019 Andy Jiang. All rights reserved.
//

import UIKit
import Firebase
import EFCountingLabel



class ResultsViewController: UIViewController {
    
    var percent = 0
    var numOfQuestions = 10
    var totalScorePossible = 0
    var numOfQuestionsCorrect = UserDefaults.standard.integer(forKey: "NumOfQuestionsCorrect")
    var gameScore = UserDefaults.standard.integer(forKey: "Score")
    
    
    //Connection of UI elements from storyboard to code.
    @IBOutlet weak var percentLabel: EFCountingLabel!
    @IBOutlet weak var correctlyAnsweredLabel: EFCountingLabel!
    @IBOutlet weak var numOfQuestionsLabel: EFCountingLabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var pointLabel: EFCountingLabel!
    
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()
        checkHighscore()
        updateAverageScore()
        
    }
    
    @IBAction func onRestart(_ sender: Any) {
         self.present((self.storyboard?.instantiateViewController(withIdentifier: "GameView"))!, animated: false, completion: nil)
        
    }
    
    @IBAction func onHome(_ sender: Any) {
         self.present((self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController"))!, animated: false, completion: nil)
    }
    
    @IBAction func onShare(_ sender: Any) {
        share()
    }
    
    
    func setup() {
        
        percent = Int((Double(numOfQuestionsCorrect) / Double(numOfQuestions)) * 100)
        totalScorePossible = (numOfQuestions * 15) + (numOfQuestions * 18)
        
        //Game Stats Setup
        pointLabel.format = "%d"
        numOfQuestionsLabel.format = "%d"
        correctlyAnsweredLabel.format = "%d"
        percentLabel.format = "%d%"
            
        pointLabel.countFrom(CGFloat(0), to: CGFloat(gameScore))
        pointLabel.completionBlock = {
            () in
            self.numOfQuestionsLabel.countFrom(CGFloat(0), to: CGFloat(self.numOfQuestions))
        }
        numOfQuestionsLabel.completionBlock = {
            () in
            self.correctlyAnsweredLabel.countFrom(CGFloat(0), to: CGFloat(self.numOfQuestionsCorrect))
        }
        correctlyAnsweredLabel.completionBlock = {
            () in
            self.percentLabel.countFrom(CGFloat(0), to: CGFloat(self.percent))
        }
        
        
        //Bottom Buttons Setup
        restartButton.layer.cornerRadius = 0.2 * restartButton.bounds.size.height
        restartButton.clipsToBounds = false
        restartButton.setImage(UIImage(named: "restart"), for: .normal)
        restartButton.contentMode = .center
        restartButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        restartButton.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        restartButton.layer.shadowOpacity = 1.0
        restartButton.layer.shadowRadius = 0.0
        restartButton.layer.masksToBounds = false
        
        homeButton.layer.cornerRadius = 0.2 * homeButton.bounds.size.height
        homeButton.clipsToBounds = false
        homeButton.setImage(UIImage(named: "mainmenu"), for: .normal)
        homeButton.contentMode = .center
        homeButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        homeButton.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        homeButton.layer.shadowOpacity = 1.0
        homeButton.layer.shadowRadius = 0.0
        homeButton.layer.masksToBounds = false
        //mainMenuButton.imageView?.contentMode = .scaleAspectFit
        
        shareButton.layer.cornerRadius = 0.2 * shareButton.bounds.size.height
        shareButton.clipsToBounds = false
        shareButton.setImage(UIImage(named: "share"), for: .normal)
        shareButton.contentMode = .center
        shareButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        shareButton.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        shareButton.layer.shadowOpacity = 1.0
        shareButton.layer.shadowRadius = 0.0
        shareButton.layer.masksToBounds = false
        
        highScoreLabel.alpha = 0

        
    
    }
    
    //Share function that is called when share  button is clicked
    func share() {
        
        //Changing of topic in UserDefaults to acceptable form for message
        let topic = UserDefaults.standard.string(forKey: "Topic")
        var say = "Test"
        
        if topic == "fblamix-questions" {
            say = "FBLA-Mix"
        } else if topic == "computerconcepts-questions" {
            say = "Computer Concepts"
        } else if topic == "economics-questions" {
            say = "FBLA Economics"
        } else if topic == "networkdesign-questions" {
            say = "Network Design"
        } else if topic == "businesslaw-questions" {
            say = "Business Law"
        }
        
        //Screenshot of screen that consists of the results screen
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Message to be displayed
        let textToShare = "Playing Fliz, its so fun! My score on \(say) is \(UserDefaults.standard.integer(forKey: "Score")). Can you beat it? Get Fliz here: "
        //FORMAT is: http://itunes.apple.com/app/idXXXXXXXXX
        if let myWebsite = URL(string: "http://itunes.apple.com/app/ballz/id113609950") { //Enter link to your app here: TODO: ADD ID
            let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            //
            
            //activityVC.popoverPresentationController?.sourceView = sender
            //self.present(activityVC, animated: true, completion: nil)
            
            //UIApplication.inputViewController?.present(activityVC, animated: true, completion: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    //Function that is called to check if score higher than previous scores
    func checkHighscore() {
        
        let topic = UserDefaults.standard.string(forKey: "Topic")
        let ref = Database.database().reference(fromURL: "https://fliz-andyjiang.firebaseio.com/")
        let userID = Auth.auth().currentUser?.uid
        ref.child(topic!).child("highscores").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let highscore = value?["score"] as? String ?? ""
          
            if self.gameScore > (highscore as NSString).integerValue {
                self.highScoreLabel.alpha = 1
                ref.child(topic!).child("highscores").child(userID!).updateChildValues(["score": String(self.gameScore)])
            }
           
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //Function to update average when new score from a quiz is given
    func updateAverageScore() {
        let ref = Database.database().reference(fromURL: "https://fliz-andyjiang.firebaseio.com/")
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let averageScore = value?["average-score"] as? String ?? ""
            let gamesPlayed = value?["games-played"] as? String ?? ""
            if (averageScore as NSString).integerValue == 0 {
                ref.child("users").child(userID!).updateChildValues(["average-score": String(self.gameScore)])
            } else {
                let newAverage = (((averageScore as NSString).integerValue * (gamesPlayed as NSString).integerValue) + self.gameScore) / ((gamesPlayed as NSString).integerValue + 1)
                ref.child("users").child(userID!).updateChildValues(["average-score": String(newAverage)])
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    

    
    
}

