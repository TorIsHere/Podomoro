//
//  ViewController.swift
//  Pomodoro
//
//  Created by Kittikorn Ariyasuk on 7/24/2559 BE.
//  Copyright © 2559 Kittikorn Ariyasuk. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {

    @IBOutlet weak var color1: UIView!
    @IBOutlet weak var color2: UIView!
    @IBOutlet weak var color3: UIView!
    @IBOutlet weak var color4: UIView!
    @IBOutlet weak var color5: UIView!
    @IBOutlet weak var color6: UIView!
    @IBOutlet weak var color7: UIView!
    @IBOutlet weak var color8: UIView!
    @IBOutlet weak var color9: UIView!
    @IBOutlet weak var color10: UIView!
    @IBOutlet weak var color11: UIView!
    @IBOutlet weak var color12: UIView!
    
    @IBAction func onSelectColor(sender: UIButton) {
        print(sender.tag)
        self.colorPickerViewModel.selectedColor = colorPickerViewModel.uiColors[sender.tag - 1]
        performSegueWithIdentifier("goToWatch", sender: self)
    }
    
    @IBAction func unwindToColorPickerView(segue: UIStoryboardSegue) {
    
    }
    
    
    var colorPickerViewModel:ColorPickerViewModel = ColorPickerViewModel()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var token: dispatch_once_t = 0
        dispatch_once(&token) { () -> Void in
            self.inverseFlipAnimation()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var token: dispatch_once_t = 0
        dispatch_once(&token) { () -> Void in
            self.initFlipAnimation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToWatch" {
            if let desVC = segue.destinationViewController as? StopWatchViewController {
                desVC.stopWatchViewModel = StopWatchViewModel()
                desVC.stopWatchViewModel.bgColor = self.colorPickerViewModel.selectedColor
            }
        }
        
    }
    
    func inverseFlipAnimation() {
        let colorViewsSet1:[UIView] = [color1, color2, color3, color4]
        let colorViewsSet2:[UIView] = [color6]
        let colorViewsSet3:[UIView] = [color8, color9, color10, color11, color12]
        for colorView in colorViewsSet1 {
            colorView.transform = CGAffineTransformMakeScale(-1, 1)
        }
        for colorView in colorViewsSet2 {
            colorView.transform = CGAffineTransformMakeScale(-1, 1)
        }
        for colorView in colorViewsSet3 {
            colorView.transform = CGAffineTransformMakeScale(-1, 1)
        }
    }
    
    
    func initFlipAnimation() {
        let colorViewsSet1:[UIView] = [color1, color2, color3, color4]
        let colorViewsSet2:[UIView] = [color6]
        let colorViewsSet3:[UIView] = [color8, color9, color10, color11, color12]
        
        UIView.animateWithDuration(0.7, animations: {
            for colorView in colorViewsSet1 {
                colorView.transform = CGAffineTransformMakeScale(1, 1)
            }
        }) { (completed:Bool) in
            UIView.animateWithDuration(0.5, animations: {
                for colorView in colorViewsSet2 {
                    colorView.transform = CGAffineTransformMakeScale(1, 1)
                }
                }, completion: { (completed:Bool) in
                    UIView.animateWithDuration(0.7, animations: {
                        for colorView in colorViewsSet3 {
                            colorView.transform = CGAffineTransformMakeScale(1, 1)
                        }
                    })
            })
        }
    }
}

