//
//  WelcomeViewController.swift
//  Pomodoro
//
//  Created by Kittikorn Ariyasuk on 7/24/2559 BE.
//  Copyright © 2559 Kittikorn Ariyasuk. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel1: UILabel!
    @IBOutlet weak var welcomeLabel2: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    let PREFER_TEXT_SIZE:[CGFloat] = [64, 80, 96, 102]
    var prefertextSize:CGFloat = 32
    
    
    @IBAction func unwindToWelcomView(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureView()
        self.animateButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        /*if UIDevice.myModelName() == "iPhone 4s" {
            prefertextSize = PREFER_TEXT_SIZE[0]
        } else if UIDevice.myModelName() == "iPhone 5" {
            prefertextSize = PREFER_TEXT_SIZE[1]
        } else if UIDevice.myModelName() == "iPhone 5s" {
            prefertextSize = PREFER_TEXT_SIZE[1]
        } else if UIDevice.myModelName() == "iPhone 6" {
            prefertextSize = PREFER_TEXT_SIZE[2]
        } else if UIDevice.myModelName() == "iPhone 6s" {
            prefertextSize = PREFER_TEXT_SIZE[2]
        } else if UIDevice.myModelName() == "iPhone 6 Plus" {
            prefertextSize = PREFER_TEXT_SIZE[3]
        } else if UIDevice.myModelName() == "iPhone 6s Plus" {
            prefertextSize = PREFER_TEXT_SIZE[3]
        }*/
        
        if UIDevice.myScrennSize() == "3.5" {
            prefertextSize = PREFER_TEXT_SIZE[0]
        } else if UIDevice.myScrennSize() == "4.0"  {
            prefertextSize = PREFER_TEXT_SIZE[1]
        } else if UIDevice.myScrennSize() == "4.7"  {
            prefertextSize = PREFER_TEXT_SIZE[2]
        } else if UIDevice.myScrennSize() == "5.5"  {
            prefertextSize = PREFER_TEXT_SIZE[3]
        }
        
        self.welcomeLabel1.font = self.welcomeLabel1.font.fontWithSize(prefertextSize)
        self.welcomeLabel2.font = self.welcomeLabel2.font.fontWithSize(prefertextSize)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func animateButton() {
        let bouncingAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        bouncingAnimation.toValue = -8
        bouncingAnimation.duration = 0.4
        bouncingAnimation.repeatCount = .infinity
        
        self.nextButton.layer.addAnimation(bouncingAnimation, forKey: "bouncingAnimation")
    }
}
