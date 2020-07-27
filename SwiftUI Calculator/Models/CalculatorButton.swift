//
//  CalculatorButton.swift
//  SwiftUI Calculator
//
//  Created by Reinaldo Haynes on 7/24/20.
//

import SwiftUI

enum CalculatorButton: String {
    
    case ac = "AC", clear = "C",
         plus, minus, multiply, divide, equal,
         plusMinus = "plus.slash.minus",
         percent, negative = "-", period = ".",
         zero = "0", one = "1",
         two = "2", three = "3",
         four = "4", five = "5",
         six = "6", seven = "7",
         eight = "8", nine = "9"
    
    var label: String {
        rawValue
    }
    
    struct CalculatorLayout {
        var basic: [[CalculatorButton]]
    }

    static var layout: CalculatorLayout {
        CalculatorLayout(
            basic: [
                [.ac, .plusMinus, .percent, .divide],
                [.seven, .eight, .nine, .multiply],
                [.four, .five, .six, .minus],
                [.one, .two, .three, .plus],
                [.zero, .period, .equal]
            ]
        )
    }
    
    var isImage: Bool {
        switch (self) {
            case .zero, .one, .two, .three, .four, .five, .six,
                 .seven, .eight, .nine, .period, .ac, .clear:
                return false
            default:
                return true
        }
    }
    
    var isPrintable: Bool {
        switch (self) {
            case .zero, .one, .two, .three, .four, .five,
                 .six, .seven, .eight, .nine, .period:
                return true
            default:
                return false
        }
    }
    
    var isOperator: Bool {
        switch (self) {
        case .plus, .minus, .multiply, .divide, .equal, .percent:
                return true
            default:
                return false
        }
    }
    
    var isLogicOperator: Bool {
        switch (self) {
            case .plus, .minus, .multiply, .divide:
                return true
            default:
                return false
        }
    }
    
    var color: ButtonColor {
        switch (self) {
            case .ac, .plusMinus, .percent:
                return ButtonColor(foregroundColor: .black, backgroundColor: Color(.lightGray))
            case .divide, .multiply, .minus, .plus, .equal:
                return ButtonColor(foregroundColor: .white, backgroundColor: .orange)
            default:
                return ButtonColor(foregroundColor: .white, backgroundColor: Color(white: 0.2))
        }
    }
}
