//
//  CalculatorActions.swift
//  SwiftUI Calculator
//
//  Created by Reinaldo Haynes on 7/24/20.
//

import SwiftUI



class CalculatorActions: ObservableObject {
    // Storage
    @Published var displayContent: String = "0"
    private var lastDisplayMemory: String = ""
    private var lastButtonPressed: CalculatorButton?
    private var lastLogicOperatorButtonPressed: CalculatorButton?
    private var lastLogicValueMemory: Double?
    private var buttonPressCount: Int = 0
    
    // Actions
    private var shouldClearViewNextClick: Bool = false
    private var wasPeriodPressed: Bool = false
    private var wasAnyButtonPressed: Bool = false
    
    // Common Labels
    private let negativeLabel: String = CalculatorButton.negative.label
    private let zeroLabel: String = CalculatorButton.zero.label
    private let negativeZeroLabel: String =
        CalculatorButton.negative.label + CalculatorButton.zero.label
    private let negativeZeroPeriodLabel: String =
        CalculatorButton.negative.label + CalculatorButton.zero.label + CalculatorButton.period.label
    private let zeroPeriodLabel: String =
        CalculatorButton.zero.label + CalculatorButton.period.label
    
    // PUBLIC FUNCTIONS
    
    func updateDisplay(button: CalculatorButton) -> Void {
        if button == .ac {
            allClearWasClicked()
        }
        
        if button == .plusMinus {
            plusMinusWasClicked()
        }
        
        // Check for isOperators & .plusMinus
        if button.isOperator {
            operatorButtonWasClicked(button: button)
        }
        
        if button.isPrintable {
            printableButtonWasClicked(button: button)
        }
        
        lastButtonPressed = button
    }
    
    // PRIVATE FUNCTIONS
    
    private func appendToDisplay(label: String) -> Void {
        buttonPressCount += 1
        displayContent = displayContent + label
    }
    
    private func clearDisplay() -> Void {
        buttonPressCount = 0
        displayContent = ""
    }
    
    private func doEqualOperation() -> Void {
        let lastValue = convertDisplayStringToDouble(display: lastDisplayMemory)
        
        if lastButtonPressed != .equal {
            // Store last value used for logic operators for .equal
            lastLogicValueMemory = convertDisplayStringToDouble(display: displayContent)
        }
        
        let calculatedValue = evaluateValues(
            last: lastValue,
            current: lastLogicValueMemory!,
            button: lastLogicOperatorButtonPressed!)
        
        let displayValue = convertDoubleToDisplayString(num: calculatedValue)
        clearDisplay()
        appendToDisplay(label: displayValue)
    }
    
    private func doLogicOperation(button: CalculatorButton) -> Void {
        let lastMemory = convertDisplayStringToDouble(
            display: !lastDisplayMemory.isEmpty ? lastDisplayMemory : "0"
        )
        let lastValue = convertDisplayStringToDouble(display: displayContent)
        var calculatedValue: Double?
        
        if !lastDisplayMemory.isEmpty &&
            !(lastButtonPressed?.isLogicOperator ?? false)  {
            calculatedValue = evaluateValues(
                last: lastMemory,
                current: lastValue,
                button: button)
            
            let displayValue = convertDoubleToDisplayString(num: calculatedValue!)
            clearDisplay()
            appendToDisplay(label: displayValue)
        }
        
        // Store logic operator for .percent & .equal
        lastLogicOperatorButtonPressed = button
    }
    
    private func doPercentOperation() -> Void {
        if lastDisplayMemory.isEmpty {
            let percentConvertDisplay = percentageConversionDisplay(display: displayContent)
            clearDisplay()
            appendToDisplay(label: percentConvertDisplay)
        }
        // when memory has storage value
        else if !lastDisplayMemory.isEmpty {
            // If lastLogicOperatorButtonPressed = .multiply || .divide
            // Do percent conversion
            if lastLogicOperatorButtonPressed == .multiply ||
                lastLogicOperatorButtonPressed == .divide {
                let percentConvertDisplay = percentageConversionDisplay(display: displayContent)
                clearDisplay()
                appendToDisplay(label: percentConvertDisplay)
            }
            else if lastLogicOperatorButtonPressed == .plus ||
                        lastLogicOperatorButtonPressed == .minus {
                let percentConvertDisplay = percentageConversionDisplay(display: displayContent)
                let convertedPercentDisplay = convertDisplayStringToDouble(display: percentConvertDisplay)
                let convertedlastMemoryDisplay = convertDisplayStringToDouble(display: lastDisplayMemory)
                let percentOfMemoryValue = convertedlastMemoryDisplay * convertedPercentDisplay
                let percentValueDisplay = convertDoubleToDisplayString(num: percentOfMemoryValue)
                
                clearDisplay()
                appendToDisplay(label: percentValueDisplay)
            }
        }
    }
    
    private func operatorButtonWasClicked(button: CalculatorButton) -> Void {
        shouldClearViewNextClick = true
        wasPeriodPressed = false
        
        // .plus, .minus, .multiply, or .divide clicked
        if button.isLogicOperator {
            doLogicOperation(button: button)
        }
        
        // .percent clicked
        if button == .percent {
            doPercentOperation()
        }
        
        // .equal clicked
        if button == .equal &&
            lastLogicOperatorButtonPressed != nil {
            doEqualOperation()
        }
        
        // Store new display
        lastDisplayMemory = displayContent
    }
    
    private func plusMinusWasClicked() -> Void {
        if shouldClearViewNextClick || displayContent == zeroLabel {
            clearDisplay()
            appendToDisplay(label: negativeZeroLabel)
            shouldClearViewNextClick = false
        }
        else if displayContent == negativeZeroPeriodLabel {
            clearDisplay()
            appendToDisplay(label: zeroPeriodLabel)
        }
        else if displayContent == zeroPeriodLabel {
            clearDisplay()
            appendToDisplay(label: negativeZeroPeriodLabel)
        }
        else {
            var value = convertDisplayStringToDouble(display: displayContent)
            value = value * -1
            clearDisplay()
            appendToDisplay(label: convertDoubleToDisplayString(num: value))
        }
    }
    
    private func printableButtonWasClicked(button: CalculatorButton) -> Void {
        // .period check
        if button == .period && wasPeriodPressed { return }
        else if button == .period && !wasPeriodPressed {
            if wasAnyButtonPressed {
                buttonPressCount -= 1
            }
            if displayContent == negativeZeroLabel {
                clearDisplay()
                appendToDisplay(label: negativeZeroLabel)
            }
            
            wasPeriodPressed = true
        }
        
        // Clear display if .zero
        if (displayContent == zeroLabel && button != .period) || shouldClearViewNextClick {
            clearDisplay()
            // Display .zero if .period clicked when next event clears
            if button == .period && shouldClearViewNextClick {
                appendToDisplay(label: zeroLabel)
            }
            shouldClearViewNextClick = false
        }
        else if displayContent == negativeZeroLabel && button != .period {
            clearDisplay()
            appendToDisplay(label: negativeLabel)
        }
        
        // Button Press Limit with .plusMinus exception
        if buttonPressCount >= 9 &&
            button != .plusMinus {
            return
        }
        
        wasAnyButtonPressed = true
        appendToDisplay(label: button.label)
    }
    
    private func allClearWasClicked() -> Void {
        displayContent = "0"
        lastDisplayMemory = ""
        lastButtonPressed = nil
        lastLogicValueMemory = nil
        lastLogicOperatorButtonPressed = nil
        buttonPressCount = 0
        wasPeriodPressed = false
        shouldClearViewNextClick = false
        wasAnyButtonPressed = false
    }
    
    // HELPER FUNCTIONS
    
    private func convertDoubleToDisplayString(num: Double) -> String {
        "\(Double(num))"
    }
    
    private func convertDisplayStringToDouble(display: String) -> Double {
        Double(display)!
    }
    
    private func evaluateValues(last: Double, current: Double, button: CalculatorButton) -> Double {
        var value: Double
        switch button {
            case .plus:
                value = last + current
            case .minus:
                value = last - current
            case .multiply:
                value = last * current
            case .divide:
                value = last / current
            default:
                value = current
        }
        if value.isNaN { value = 0 }
        return value
    }
    
    private func percentageConversionDisplay(display: String) -> String {
        let displayValue = convertDisplayStringToDouble(display: display)
        let percentConvert = displayValue * 0.01
        return convertDoubleToDisplayString(num: percentConvert)
    }
}


