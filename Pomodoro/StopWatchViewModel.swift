//
//  StopWatchViewModel.swift
//  Pomodoro
//
//  Created by Kittikorn Ariyasuk on 7/24/2559 BE.
//  Copyright © 2559 Kittikorn Ariyasuk. All rights reserved.
//

import UIKit

class StopWatchViewModel: NSObject {
    
    enum AppState : String {
        case waitInput = "waitInput"
        case taskInPuted = "taskInPuted"
        case taskCountDown = "taskCountDown"
        case restCountDown = "restCountDown"
    }
    
    dynamic var bgColor:UIColor!
    
    dynamic private(set) var appStateRaw: String?
    var appState : AppState? {
        didSet {
            appStateRaw = appState?.rawValue
        }
    }
    
    
    
    override init() {
        super.init()
        self.appState = .waitInput
        self.bgColor = UIColor.whiteColor()
    }
    
}
