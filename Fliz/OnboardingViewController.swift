//
//  OnboardingViewController.swift
//  FlashQuiz
//
//  Created by Andy Jiang on 1/4/19.
//  Copyright © 2019 Andy Jiang. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    //Connection of UI elements from storyboard to code.
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPaperOnboardingView()
        view.bringSubviewToFront(signUpButton)
        view.bringSubviewToFront(logInButton)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        
        presentDetail((storyboard?.instantiateViewController(withIdentifier: "SignUpViewController"))!)
    }
    
    @IBAction func onLogIn(_ sender: Any) {
        presentDetail((storyboard?.instantiateViewController(withIdentifier: "LogInViewController"))!)
    }
    
    // Creating onboarding view
    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // Add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
    
    //Setup of onboarding view
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        
        let backgroundColorSlideOne = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)
        let backgroundColorSlideTwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1)
        let backgroundColorSlideThree = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1)
        let backgroundColorSlideFour = UIColor(red: 237/255, green: 162/255, blue: 92/255, alpha: 1)
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descriptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        
        
        return [
            //First page of onboarding screen (start page)
            OnboardingItemInfo(informationImage: UIImage(named: "logo.png")!,
                               title: "",
                               description: "Study and learn through thousands of quizzes on varity of topics. Improve your test taking skills through varies techniques.",
                               pageIcon: UIImage(named: "transparent.png")!,
                               color: backgroundColorSlideOne,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descriptionFont),
            //Second page of onboarding screen (start page)
            OnboardingItemInfo(informationImage: UIImage(named: "quiz.png")!,
                               title: "Quiz",
                               description: "Take quizzes based on wide variety of topics. Learn from your mistakes and improve your speed.",
                               pageIcon: UIImage(named: "transparent.png")!,
                               color: backgroundColorSlideTwo,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descriptionFont),
            //Third page of onboarding screen (start page)
            OnboardingItemInfo(informationImage: UIImage(named: "test.png")!,
                               title: "Test-taking skills",
                               description: "Improve your test-taking skills through in-game features that encourage you to work faster.",
                               pageIcon: UIImage(named: "transparent.png")!,
                               color: backgroundColorSlideThree,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descriptionFont),
            //Four page of onboarding screen (start page)
            OnboardingItemInfo(informationImage: UIImage(named: "compete.png")!,
                               title: "Compete",
                               description: "Compete against your friends to claim the highest score on a quiz.",
                               pageIcon: UIImage(named: "transparent.png")!,
                               color: backgroundColorSlideFour,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descriptionFont)
            ][index]
    }
    
    //Configuration of items in onboarding screen
    func onboardingItemsCount() -> Int {
        return 4
    }
    
    func onboardingPageItemSelectedRadius() -> CGFloat {
        return 10
    }
    
    func onboardinPageItemRadius() -> CGFloat {
        return 5
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


