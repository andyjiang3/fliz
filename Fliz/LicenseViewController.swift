//
//  LicenseViewController.swift
//  Fliz
//
//  Created by Andy Jiang on 2/21/19.
//  Copyright © 2019 Andy Jiang. All rights reserved.
//

import UIKit

class LicenseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "back"), style: .done, target: self, action: #selector(goBack))
        
    }
    
    //Go back function for navigation bar
    @objc func goBack() {
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
