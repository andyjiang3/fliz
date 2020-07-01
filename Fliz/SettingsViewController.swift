//
//  SettingsViewController.swift
//  Fliz
//
//  Created by Andy Jiang on 2/21/19.
//  Copyright © 2019 Andy Jiang. All rights reserved.
//

import UIKit
import QuickTableViewController
import Firebase

final class SettingsViewController: QuickTableViewController {
    
    var email = ""
    var username = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "back"), style: .done, target: self, action: #selector(goBack))
        
        render()
        
        
    }
    
    //Go back function for navigation bar
    @objc func goBack() {
         self.present((self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController"))!, animated: false, completion: nil)
    }
    
    //Gather and setup of the settings page
    func render() {
        let ref = Database.database().reference(fromURL: "https://fliz-andyjiang.firebaseio.com/")
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value from database
            let value = snapshot.value as? NSDictionary
            let username2 = value?["username"] as? String ?? ""
            let email2 = value?["email"] as? String ?? ""
            
            self.username = username2
            self.email = email2
            
            self.tableContents = [
                Section(title: "Account", rows: [
                    NavigationRow(title: "Email", subtitle: Subtitle.rightAligned(self.email), icon: .none, action: .none),
                    NavigationRow(title: "Username", subtitle: Subtitle.rightAligned(self.username), icon: .none, action: .none)
                    ]),
                
                Section(title: "About", rows: [
                    NavigationRow(title: "Terms of Service", subtitle: .none, icon: .none, action:  { _ in self.termsClicked()}),
                    NavigationRow(title: "License", subtitle: .none, icon: .none, action: { _ in self.licenseClicked()}),
                    
                    ]),
                
                Section(title: "Support", rows: [
                    NavigationRow(title: "Contact", subtitle: .none, icon: .none, action: { _ in self.contactClicked()}),
                    NavigationRow(title: "Report a bug", subtitle: .none, icon: .none, action: { _ in self.bugClicked()})
                    ]),
                
                Section(title: "", rows: [
                    TapActionRow(title: "Log out", action: { _ in self.logoutClicked()})
                    ]),
            ]
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //Function that is called based on different elements that are clicked in settings page
    func termsClicked() {
        presentDetail((storyboard?.instantiateViewController(withIdentifier: "TermsNavigation"))!)
    }
    
    func licenseClicked() {
        presentDetail((storyboard?.instantiateViewController(withIdentifier: "LicenseNavigation"))!)
    
    }
    
    func contactClicked() {
        
        presentDetail((storyboard?.instantiateViewController(withIdentifier: "ContactNavigation"))!)

    }
    
    func bugClicked() {
        presentDetail((storyboard?.instantiateViewController(withIdentifier: "BugNavigation"))!)
    }
    
    func logoutClicked() {
        
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


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
