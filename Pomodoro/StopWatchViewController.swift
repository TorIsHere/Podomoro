//
//  StopWatchViewController.swift
//  Pomodoro
//
//  Created by Kittikorn Ariyasuk on 7/24/2559 BE.
//  Copyright © 2559 Kittikorn Ariyasuk. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SwiftyProgressBar

class StopWatchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var taskInput: UITextField!
    @IBOutlet weak var currentTaskLabel: UILabel!
    @IBOutlet weak var timeNumber: UILabel!
    @IBOutlet weak var progressView: CircularProgressView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func onStart(sender: AnyObject) {
        if self.stopWatchViewModel.appState == .taskInPuted {
            self.stopWatchViewModel.appState  = .taskCountDown
        }
    }
    
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
        self.progressView.startAngle = -90
        self.progressView.endAngle = -90
        self.progressView.bgColor = UIColor.clearColor()
        self.progressView.primaryColor = UIColor.whiteColor()
        self.progressView.secondaryColor = UIColor.whiteColor()
        
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
        if let _ = self.taskInput.text {
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
                        weakSelf.stopWatchViewModel.count = 0
                        weakSelf.startTimemer()
                        break
                    default:
                        break
                    }
                }
            }
        }
        self.stopWatchViewModel.rac_valuesForKeyPath("count", observer: self.stopWatchViewModel).subscribeNext { [weak self] (next:AnyObject!) in
            if let weakSelf = self {
                if let count = next as? Int {
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.timeOutInSecond = count
                    weakSelf.timeNumber.text = String(25 - Int(count/60))
                    weakSelf.progressView.setProgress( CGFloat(count) * 100 / (60 * 25), duration: 0.1)//.animate(CGFloat(count)/60 / 25, duration: 0.1)
                }
            }
        }
        
    }
    
    func startTimemer() {
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(StopWatchViewController.countdown), userInfo: nil, repeats: true)
    }
    
    func countdown() {
        self.stopWatchViewModel.count = NSNumber(int: self.stopWatchViewModel.count.intValue + 1)
    }

}
