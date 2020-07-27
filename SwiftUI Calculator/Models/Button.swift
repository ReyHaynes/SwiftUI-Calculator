//
//  Button.swift
//  SwiftUI Calculator
//
//  Created by Reinaldo Haynes on 7/24/20.
//

import SwiftUI
import UIKit

struct ButtonColor {
    let foregroundColor: Color
    let backgroundColor: Color
}

struct ButtonSizing {
    var spacing: CGFloat? = 20
    
    var fontSize: CGFloat = 30
    
    var width: CGFloat {
        (UIScreen.main.bounds.width - self.spacing!) / 4 - self.spacing!
    }
    
    init() {}
    
    init(spacing: CGFloat?) { self.spacing = spacing }
}
