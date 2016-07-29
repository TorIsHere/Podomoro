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
        case inputComplete = "inputComplete"
        case taskCountDown = "taskCountDown"
        case pauseCountDown = "pauseCountDown"
        case sprintEnd = "sprintEnd"
        case restCountDown = "restCountDown"
        case pauseRestCountDown = "pauseRestCountDown"
        case restEnd = "restEnd"
    }
    
    dynamic var bgColor:UIColor!
    dynamic var count:NSNumber!
    dynamic var sprintCount:NSNumber!
    
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
