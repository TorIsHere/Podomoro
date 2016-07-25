//
//  StopWatchViewController.swift
//  Pomodoro
//
//  Created by Kittikorn Ariyasuk on 7/24/2559 BE.
//  Copyright © 2559 Kittikorn Ariyasuk. All rights reserved.
//

import UIKit
import ReactiveCocoa

class StopWatchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var taskInput: UITextField!
    @IBOutlet weak var currentTaskLabel: UILabel!
    @IBOutlet weak var timeNumber: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    var stopWatchViewModel:StopWatchViewModel = StopWatchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.taskInput.delegate = self
        self.configureView()
        self.bindingViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView() {
        self.view.backgroundColor = stopWatchViewModel.bgColor
        //self.progressView
        
        self.taskInput.backgroundColor = UIColor.clearColor()
        self.taskInput.borderStyle = UITextBorderStyle.None
        self.taskInput.attributedPlaceholder = NSAttributedString(string:"I want to focus on ...",
                                                               attributes:[NSForegroundColorAttributeName: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let task = self.taskInput.text {
            self.taskInput.resignFirstResponder()
            self.stopWatchViewModel.appState = .taskInPuted
        }
        
        return false
    }
    
    func bindingViewModel() {
        self.stopWatchViewModel.rac_valuesForKeyPath("appStateRaw", observer: self.stopWatchViewModel).subscribeNext { [weak self] (next:AnyObject!) in
            if let weakSelf = self {
                if let appState = weakSelf.stopWatchViewModel.appState {
                    switch appState {
                    case .taskInPuted:
                        weakSelf.currentTaskLabel.text = weakSelf.taskInput.text!
                        weakSelf.currentTaskLabel.hidden = false
                        weakSelf.progressView.hidden = false
                        weakSelf.taskInput.hidden = true
                        break
                    case .taskCountDown:
                        break
                    default:
                        break
                    }
                }
            }
        }
        
    }
    

}
