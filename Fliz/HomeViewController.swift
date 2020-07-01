//
//  FirstViewController.swift
//  Fliz
//
//  Created by Andy Jiang on 1/5/19.
//  Copyright © 2019 Andy Jiang. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    //Connection of UI elements from storyboard to code.
    @IBOutlet weak var featureOneView: UIView!
    @IBOutlet weak var computerConceptsView: UIView!
    @IBOutlet weak var businessLawView: UIView!
    @IBOutlet weak var networkDesignView: UIView!
    @IBOutlet weak var fblaEconomicsView: UIView!

    @IBOutlet weak var importMessage: UITextView!
    
    //Setting for Views
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 25.0
    private var fillColor: UIColor = .yellow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Tap gesture setup when user tap on topic. Direct to game (questios).
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(featureOneClicked(tapGestureRecognizer:)))
        featureOneView.isUserInteractionEnabled = true
        featureOneView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(computerClicked(tapGestureRecognizer:)))
        computerConceptsView.isUserInteractionEnabled = true
        computerConceptsView.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(businessClicked(tapGestureRecognizer:)))
        businessLawView.isUserInteractionEnabled = true
        businessLawView.addGestureRecognizer(tapGestureRecognizer3)
        
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(networkClicked(tapGestureRecognizer:)))
        networkDesignView.isUserInteractionEnabled = true
        networkDesignView.addGestureRecognizer(tapGestureRecognizer4)
        
        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(economicsClicked(tapGestureRecognizer:)))
        fblaEconomicsView.isUserInteractionEnabled = true
        fblaEconomicsView.addGestureRecognizer(tapGestureRecognizer5)
        
        //Set up elements in Home page UI.
        setup()
        
        
    }

    
    //Elements defined and setup of UI
    func setup() {
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 50))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 270, height: 50))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo2.png")
        imageView.image = image
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
        
        //Add text to Import Message
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let myString:NSString = "Create your own quiz on the Fliz website and it will show up below"
        let myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "WorkSans-SemiBold", size: 15.0)!, NSAttributedString.Key.paragraphStyle: style])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 52/255, green: 152/255, blue: 219/255, alpha: 1), range: NSRange(location:28,length:4))
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 52/255, green: 152/255, blue: 219/255, alpha: 1), range: NSRange(location:61,length:5))
        importMessage.attributedText = myMutableString
        
        
        
        //Add round corners
        featureOneView.layer.cornerRadius = 10.0
        computerConceptsView.layer.cornerRadius = 10.0
        businessLawView.layer.cornerRadius = 10.0
        networkDesignView.layer.cornerRadius = 10.0
        fblaEconomicsView.layer.cornerRadius = 10.0
        
        //Drop shadow, bottom and sides
        featureOneView.layer.shadowColor = UIColor.gray.cgColor
        featureOneView.layer.shadowOffset = CGSize(width: 0, height: 3)
        featureOneView.layer.shadowOpacity = 0.7
        featureOneView.layer.shadowRadius = 4.0
        
        computerConceptsView.layer.shadowColor = UIColor.gray.cgColor
        computerConceptsView.layer.shadowOffset = CGSize(width: 0, height: 3)
        computerConceptsView.layer.shadowOpacity = 0.7
        computerConceptsView.layer.shadowRadius = 4.0
        
        businessLawView.layer.shadowColor = UIColor.gray.cgColor
        businessLawView.layer.shadowOffset = CGSize(width: 0, height: 3)
        businessLawView.layer.shadowOpacity = 0.7
        businessLawView.layer.shadowRadius = 4.0
        
        networkDesignView.layer.shadowColor = UIColor.gray.cgColor
        networkDesignView.layer.shadowOffset = CGSize(width: 0, height: 3)
        networkDesignView.layer.shadowOpacity = 0.7
        networkDesignView.layer.shadowRadius = 4.0
        
        fblaEconomicsView.layer.shadowColor = UIColor.gray.cgColor
        fblaEconomicsView.layer.shadowOffset = CGSize(width: 0, height: 3)
        fblaEconomicsView.layer.shadowOpacity = 0.7
        fblaEconomicsView.layer.shadowRadius = 4.0
        
        
        
    }

    //Functionalizes what happens when user click on topic - they will be send to GameView.
    @objc func featureOneClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        
        
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "GameView"))!, animated: false, completion: nil)
        UserDefaults.standard.set("fblamix-questions", forKey: "Topic")
        
    }
    
    @objc func computerClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        
        
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "GameView"))!, animated: false, completion: nil)
        UserDefaults.standard.set("computerconcepts-questions", forKey: "Topic")
        
    }
    
    @objc func businessClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        
        
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "GameView"))!, animated: false, completion: nil)
        UserDefaults.standard.set("businesslaw-questions", forKey: "Topic")
        
    }
    
    @objc func networkClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        
        
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "GameView"))!, animated: false, completion: nil)
        UserDefaults.standard.set("networkdesign-questions", forKey: "Topic")
        
    }
    
    @objc func economicsClicked(tapGestureRecognizer: UITapGestureRecognizer) {
        
        
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "GameView"))!, animated: false, completion: nil)
        UserDefaults.standard.set("economics-questions", forKey: "Topic")
        
    }


}

