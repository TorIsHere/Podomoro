//
//  ColorPickerViewModel.swift
//  Pomodoro
//
//  Created by Kittikorn Ariyasuk on 7/24/2559 BE.
//  Copyright © 2559 Kittikorn Ariyasuk. All rights reserved.
//

import UIKit

class ColorPickerViewModel: NSObject {
    
    dynamic var uiColor1:UIColor = UIColor.clearColor()
    dynamic var uiColor2:UIColor = UIColor.clearColor()
    dynamic var uiColor3:UIColor = UIColor.clearColor()
    dynamic var uiColor4:UIColor = UIColor.clearColor()
    dynamic var uiColor5:UIColor = UIColor.clearColor()
    dynamic var uiColor6:UIColor = UIColor.clearColor()
    dynamic var uiColor7:UIColor = UIColor.clearColor()
    dynamic var uiColor8:UIColor = UIColor.clearColor()
    dynamic var uiColor9:UIColor = UIColor.clearColor()
    dynamic var uiColor10:UIColor = UIColor.clearColor()
    dynamic var uiColor11:UIColor = UIColor.clearColor()
    dynamic var uiColor12:UIColor = UIColor.clearColor()
    dynamic var uiColors:[UIColor]!
    
    var selectedColor:UIColor?
    
    override init() {
        super.init()
        self.uiColors = [uiColor1, uiColor2, uiColor3, uiColor4,
                    uiColor5, uiColor6, uiColor7, uiColor8,
                    uiColor9, uiColor10, uiColor11, uiColor12]
    }
    
    func loadColorFromJSON() {
        if let path = NSBundle.mainBundle().pathForResource("colors", ofType: "json")
        {
            if let jsonData = NSData(contentsOfFile: path) {
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    if let colors = jsonResult["colors"] as? NSArray {
                        for count in 0..<colors.count {
                            if let color = colors[count] as? NSDictionary {
                                //uiColor1 = UIColor(red: CGFloat((color["red"]?.intValue)!)/255, green:  CGFloat((color["green"]?.intValue)!)/255, blue:  CGFloat((color["blue"]?.intValue)!)/255, alpha: 1.0)
                                self.uiColors[count] = UIColor(red: CGFloat((color["red"]?.intValue)!)/255, green:  CGFloat((color["green"]?.intValue)!)/255, blue:  CGFloat((color["blue"]?.intValue)!)/255, alpha: 1.0)
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
