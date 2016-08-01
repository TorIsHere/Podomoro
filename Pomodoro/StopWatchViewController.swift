//
//  StopWatchViewController.swift
//  Pomodoro
//
//  Created by Kittikorn Ariyasuk on 7/24/2559 BE.
//  Copyright © 2559 Kittikorn Ariyasuk. All rights reserved.
//

import UIKit
import AudioToolbox
import ReactiveCocoa
import SwiftyProgressBar

class StopWatchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var taskInput: UITextField!
    @IBOutlet weak var currentTaskLabel: UILabel!
    @IBOutlet weak var timeNumber: UILabel!
    @IBOutlet weak var progressView: CircularProgressView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var sprintLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var infoView: UIVisualEffectView!
    
    @IBAction func onBack(sender: AnyObject) {
        if self.stopWatchViewModel.appState != .waitInput {
            
            let alert = UIAlertController(title: "Alert", message: "Stop the sprint", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                self.performSegueWithIdentifier("backToColorPicker", sender: self)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                alert.removeFromParentViewController()
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            self.performSegueWithIdentifier("backToColorPicker", sender: self)
        }
    
    }
    @IBAction func onStart(sender: AnyObject) {
        if self.stopWatchViewModel.appState == .inputComplete || self.stopWatchViewModel.appState == .pauseCountDown {
            self.stopWatchViewModel.appState  = .taskCountDown
        }
        
        if self.stopWatchViewModel.appState  == .pauseRestCountDown {
            self.stopWatchViewModel.appState = .restCountDown
        }
    }
    
    @IBAction func onInfo(sender: AnyObject) {
        self.infoView.hidden = false
    }
    
    @IBAction func onCloseInfo(sender: AnyObject) {
        self.infoView.hidden = true
    }
    
    @IBAction func onPause(sender: AnyObject) {
        if self.stopWatchViewModel.appState  == .taskCountDown {
            self.stopWatchViewModel.appState = .pauseCountDown
        }
        if self.stopWatchViewModel.appState  == .restCountDown {
            self.stopWatchViewModel.appState = .pauseRestCountDown
        }
    }
    
    var stopWatchViewModel:StopWatchViewModel = StopWatchViewModel()
    var targetTime:Int = 25
    var timer:NSTimer!
    var sprintNO:Int = 1
    let sprintText = "%@ %x of 4 in sprint"
    
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
        self.progressView.lineWidth = 16
        self.progressView.bgLineWidth = 12
        self.progressView.startAngle = -90
        self.progressView.endAngle = -90
        //self.progressView.bgColor
        if let (red, green, blue, _) = UIColor.grayColor().rgb() {
            self.progressView.bgColor = UIColor(red: red, green: green, blue: blue, alpha: 0.6)
        }
        
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
            self.stopWatchViewModel.appState = .inputComplete
        }
        
        return false
    }
    
    func bindingViewModel() {
        self.stopWatchViewModel.rac_valuesForKeyPath("appStateRaw", observer: self.stopWatchViewModel).subscribeNext { [weak self] (next:AnyObject!) in
            if let weakSelf = self {
                if let appState = weakSelf.stopWatchViewModel.appState {
                    switch appState {
                    case .waitInput:
                        weakSelf.currentTaskLabel.hidden    = true
                        weakSelf.progressView.hidden        = true
                        weakSelf.startButton.hidden         = true
                        weakSelf.pauseButton.hidden         = true
                        weakSelf.actionLabel.hidden         = true
                        weakSelf.taskInput.hidden           = false
                        weakSelf.sprintLabel.hidden         = true
                        break
                    case .inputComplete:
                        weakSelf.currentTaskLabel.hidden    = false
                        weakSelf.progressView.hidden        = false
                        weakSelf.startButton.hidden         = false
                        weakSelf.pauseButton.hidden         = true
                        weakSelf.taskInput.hidden           = true
                        weakSelf.actionLabel.hidden         = true
                        weakSelf.sprintLabel.hidden         = true
                        weakSelf.stopWatchViewModel.count   = 0
                        weakSelf.targetTime                 = 25
                        weakSelf.currentTaskLabel.text = weakSelf.taskInput.text!
                        break
                    case .taskCountDown:
                        weakSelf.currentTaskLabel.hidden    = false
                        weakSelf.progressView.hidden        = false
                        weakSelf.progressView.erase()
                        weakSelf.startButton.hidden         = true
                        weakSelf.pauseButton.hidden         = false
                        weakSelf.taskInput.hidden           = true
                        weakSelf.actionLabel.hidden         = false
                        weakSelf.actionLabel.text           = "GO!!"
                        weakSelf.sprintLabel.hidden         = false
                        weakSelf.sprintLabel.text           = String(format: weakSelf.sprintText, "Task", weakSelf.sprintNO)
                        weakSelf.startTimemer()
                        break
                    case .pauseCountDown:
                        weakSelf.currentTaskLabel.hidden    = false
                        weakSelf.progressView.hidden        = false
                        weakSelf.startButton.hidden         = false
                        weakSelf.pauseButton.hidden         = true
                        weakSelf.taskInput.hidden           = true
                        weakSelf.actionLabel.hidden         = true
                        weakSelf.sprintLabel.hidden         = false
                        break
                    case .sprintEnd:
                        weakSelf.stopWatchViewModel.count   = 0
                        weakSelf.targetTime                 = 3
                        if weakSelf.sprintNO % 4 == 0 {
                            weakSelf.targetTime = 15
                        }
                        weakSelf.stopWatchViewModel.appState = .restCountDown
                        weakSelf.progressView.erase()
                        break
                    case .restCountDown:
                        weakSelf.currentTaskLabel.hidden    = false
                        weakSelf.progressView.hidden        = false
                        weakSelf.startButton.hidden         = true
                        weakSelf.pauseButton.hidden         = false
                        weakSelf.taskInput.hidden           = true
                        weakSelf.actionLabel.hidden         = false
                        weakSelf.actionLabel.text           = "Take a break!!"
                        weakSelf.sprintLabel.hidden         = false
                        weakSelf.sprintLabel.text           = String(format: weakSelf.sprintText, "Break", weakSelf.sprintNO)
                        weakSelf.startTimemer()
                        break
                    case .pauseRestCountDown:
                        weakSelf.currentTaskLabel.hidden    = false
                        weakSelf.progressView.hidden        = false
                        weakSelf.startButton.hidden         = false
                        weakSelf.pauseButton.hidden         = true
                        weakSelf.taskInput.hidden           = true
                        weakSelf.actionLabel.hidden         = true
                        break
                    case .restEnd:
                        weakSelf.currentTaskLabel.hidden    = false
                        weakSelf.progressView.hidden        = false
                        weakSelf.startButton.hidden         = true
                        weakSelf.pauseButton.hidden         = false
                        weakSelf.taskInput.hidden           = true
                        weakSelf.actionLabel.hidden         = true
                        weakSelf.stopWatchViewModel.count   = 0
                        weakSelf.targetTime                 = 25
                        if weakSelf.sprintNO + 1 % 4 == 0 {
                            weakSelf.sprintNO = 4
                        } else {
                            weakSelf.sprintNO = (weakSelf.sprintNO + 1) % 4
                        }
                        weakSelf.stopWatchViewModel.appState = .taskCountDown
                        break
                    }
                }
            }
        }
        
    }
    
    func startTimemer() {
        if self.timer == nil {
           self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(StopWatchViewController.countdown), userInfo: nil, repeats: true)
        }
    }
    
    func countdown() {
        if self.stopWatchViewModel.appState == .taskCountDown || self.stopWatchViewModel.appState == .restCountDown {
            let count = NSNumber(int: self.stopWatchViewModel.count.intValue + 1) as Int
            self.stopWatchViewModel.count = count
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.timeOutInSecond = count
            
            let sec = (targetTime * 60 - count) % 60
            let min = (targetTime * 60 - count) / 60
            
            self.timeNumber.text = String(format: "%02d", min) + ":" + String(format: "%02d", sec)
            self.progressView.setProgress( CGFloat(count) * 100 / CGFloat(60 * targetTime), duration: 0.1)
            if count == targetTime * 60 {
                if self.stopWatchViewModel.appState == .taskCountDown {
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    self.stopWatchViewModel.appState = .sprintEnd
                } else if self.stopWatchViewModel.appState == .restCountDown {
                    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    self.stopWatchViewModel.appState = .restEnd
                }
            }

        }
    }

}
