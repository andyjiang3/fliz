 //
//  GameViewController.swift
//  Fliz
//
//  Created by Andy Jiang on 1/5/19.
//  Copyright © 2019 Andy Jiang. All rights reserved.
//

import UIKit
import Firebase

class GameViewController: UIViewController {
    
    //Connection of UI elements from storyboard to code.
    @IBOutlet weak var questionLabel: UITextView!
    @IBOutlet weak var oneAnswerButton: UIButton!
    @IBOutlet weak var twoAnswerButton: UIButton!
    @IBOutlet weak var threeAnswerButton: UIButton!
    @IBOutlet weak var fourAnswerButton: UIButton!
    @IBOutlet weak var bonusTimerLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var button:UIButton = UIButton()
    
    var currentQuestion = 0
    var rightAnswerPlacement: UInt32 = 0
    var selectQuestion: UInt32 = 0
    
    var questionsArray:[UInt32] = []
    
    var questionNotAsked = false
    
    //Game Stats
    var score = 0
    var numOfQuestions = 10
    var numOfQuestionsAsked = 0
    var numOfQuestionsCorrect = 0
    
    //Timer
    var timer = Timer()
    var timeRemaining = 10.0
    var timerRunning = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startGame()
    }
    
    //Elements defined and setup of UI
    func setup() {
        
        //Tag of buttons
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 5)
        progressBar.layer.cornerRadius = 5
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 5
        progressBar.subviews[1].clipsToBounds = true
        
        oneAnswerButton.tag = 1
        twoAnswerButton.tag = 2
        threeAnswerButton.tag = 3
        fourAnswerButton.tag = 4
        
        //Set text in buttons to center
        oneAnswerButton.titleLabel?.textAlignment = .center
        twoAnswerButton.titleLabel?.textAlignment = .center
        threeAnswerButton.titleLabel?.textAlignment = .center
        fourAnswerButton.titleLabel?.textAlignment = .center
        
        
        //Set padding of buttons
        oneAnswerButton.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        twoAnswerButton.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        threeAnswerButton.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        fourAnswerButton.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        
    }
    
    //Answer Checker System
    
    @IBAction func choiceClicked(_ sender: Any) {
        
        timer.invalidate()
        
        
        button = view.viewWithTag((sender as AnyObject).tag) as! UIButton
        let answerButton = view.viewWithTag(Int(rightAnswerPlacement)) as! UIButton
        
        if ((sender as AnyObject).tag == Int(rightAnswerPlacement)) {
            
            UIButton.animate(withDuration: 1.0, animations: {
                self.button.setTitleColor(UIColor.white, for: .normal)
                self.button.backgroundColor = UIColor.init(red: 19/255, green: 143/255, blue: 9/255, alpha: 1)
            },completion: { _ in
                
                //change it back to original color
                for i in 1...4 {
                    self.button = self.view.viewWithTag(i) as! UIButton
                    self.button.setTitleColor(UIColor.init(red: 35/255, green: 37/255, blue: 40/255, alpha: 1), for: .normal)
                    self.button.backgroundColor = UIColor.white
            
                    
                }
                
                if self.timeRemaining <= 0.0 {
                    self.timeRemaining = 0.0
                }
                
                self.score += 15 + (Int(self.timeRemaining) * 2)
                self.numOfQuestionsCorrect += 1
                print("Right")
                self.bonusTimerLabel.textColor = UIColor.white
                self.timeRemaining = 10.0
                self.newQuestion()
            })
            

            
        } else {
            
            UIButton.animate(withDuration: 1.0, animations: {
                self.button.setTitleColor(UIColor.white, for: .normal)
                self.button.backgroundColor = UIColor.init(red: 186/255, green: 16/255, blue: 16/255, alpha: 1)
                answerButton.setTitleColor(UIColor.white, for: .normal)
                answerButton.backgroundColor = UIColor.init(red: 19/255, green: 143/255, blue: 9/255, alpha: 1)
            },completion: { _ in
                //change it back to original color
                for i in 1...4 {
                    self.button = self.view.viewWithTag(i) as! UIButton
                    self.button.setTitleColor(UIColor.init(red: 35/255, green: 37/255, blue: 40/255, alpha: 1), for: .normal)
                    self.button.backgroundColor = UIColor.white
                  
                }
                
                print("Wrong")
                self.bonusTimerLabel.textColor = UIColor.white
                self.timeRemaining = 10.0
                self.newQuestion()
            
                
            })
        }
        
    }
    
    //Control System
    
    func startGame() {
        
        rightAnswerPlacement = 0
        selectQuestion = 0
        questionNotAsked = false
        
        questionsArray = []
        
        score = 0
        numOfQuestionsCorrect = 0
        numOfQuestionsAsked = 0
        
        timeRemaining = 10.0
        timerRunning = false
        
        newQuestion()
        
    }
    
    func endGame() {
        
        print("Total score: \(score)")
        print("Number Correct: \(numOfQuestionsCorrect)")
        print("Number Of Questions Asked: \(numOfQuestionsAsked)")
        
        //Store stats in UserDefaults to be retrieved by ResultsController
        UserDefaults.standard.set(score, forKey: "Score")
        UserDefaults.standard.set(numOfQuestionsCorrect, forKey: "NumOfQuestionsCorrect")
        updateGamePlayed()
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "ResultsViewController"))!, animated: false, completion: nil)
    }
    
    
    
    //Question System
    
    func generateQuestions() {
        
        
        
        rightAnswerPlacement = arc4random_uniform(4) + 1//From 0 to n-1 (0-3)+1 = (1-4)
        print(rightAnswerPlacement)
        
        if (questionsArray.isEmpty == true) {
            questionNotAsked = true
            selectQuestion = arc4random_uniform(10)
        }
        
        while(!questionNotAsked) {
            selectQuestion = arc4random_uniform(10) //0-9
            for questions in self.questionsArray {
                if selectQuestion == questions {
                    self.questionNotAsked = false
                    break
                } else {
                    self.questionNotAsked = true
                }
            }
        }
        
        
        questionsArray.append(selectQuestion)
        questionNotAsked = false
            let topic = UserDefaults.standard.string(forKey: "Topic")
        
            let ref = Database.database().reference(fromURL: "https://fliz-andyjiang.firebaseio.com/")
        ref.child(topic!).child(String(selectQuestion)).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            self.startTimer()
                
            let value = snapshot.value as? NSDictionary
            let questionChoosen = value?["question"] as? String ?? ""
            let answer = value?["answer"] as? String ?? ""
                
            var button:UIButton = UIButton()
                
            self.questionLabel.text = questionChoosen
            
                
            var x = 1
                
                for i in 1...4 {
                    print(i)
                    button = self.view.viewWithTag(i) as! UIButton
                    if i == Int(self.rightAnswerPlacement) {
                        button.setTitle(answer, for: .normal)
                    } else {
                        let chooses = value![String(x)] as! String
                        print(chooses)
                       button.setTitle(chooses, for: .normal) //Question Label works. Problem with button title?
                      
                        x += 1
                    }
                }
                
                
                
            
            
            // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        
        
        
    }
    
    func newQuestion() {
        
        if numOfQuestionsAsked == numOfQuestions {
            endGame()
        } else {
            generateQuestions()
            numOfQuestionsAsked += 1
        }
      
        
    }
    
    //Timer
    
    func startTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 0.050, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        
    }
    
    @objc func timerUpdate() {
        
        if timeRemaining <= 0.0 {
            progressBar.setProgress(Float(0), animated: false)
            bonusTimerLabel.text = "0"
            bonusTimerLabel.textColor = UIColor(red: 186/255, green: 16/255, blue: 16/255, alpha: 1)
            
        } else {
            progressBar.setProgress(Float(timeRemaining)/Float(10), animated: false)
            timeRemaining -= 0.050
            bonusTimerLabel.text = "\(Int(timeRemaining))"
        }
        
        
    }
    
    func updateGamePlayed() {
        let ref = Database.database().reference(fromURL: "https://fliz-andyjiang.firebaseio.com/")
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let gamesPlayed = value?["games-played"] as? String ?? ""
            let added = (gamesPlayed as NSString).integerValue + 1
            ref.child("users").child(userID!).updateChildValues(["games-played": String(added)])
            
            
            
            
          
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    

}

