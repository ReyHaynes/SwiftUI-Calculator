//
//  ButtonView.swift
//  SwiftUI Calculator
//
//  Created by Reinaldo Haynes on 7/24/20.
//

import SwiftUI

struct ButtonView: View {
    var button: CalculatorButton
    var sizing: ButtonSizing? = ButtonSizing()
    
    var body: some View {
        ZStack {
            button.color.backgroundColor
            
            VStack {
                if button.isImage {
                    Image(systemName: button.label)
                        .font(.system(size: sizing!.fontSize, weight: .medium))
                }
                else {
                    Text(button.label)
                        .font(.system(size: sizing!.fontSize, weight: .regular))
                }
            }
            .foregroundColor(button.color.foregroundColor)
        }
        .frame(
            width: (button == .zero) ?
                sizing!.width * 2 + sizing!.spacing! :
                sizing!.width,
            height: sizing!.width, alignment: .center)
        .cornerRadius(sizing!.width)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        let buttonText: CalculatorButton = .zero
        let buttonText2: CalculatorButton = .eight
        let buttonImage: CalculatorButton = .plusMinus
        let buttonImage2: CalculatorButton = .divide
        VStack {
            HStack {
                ButtonView(button: buttonText)
                ButtonView(button: buttonText2)
            }
            HStack {
                ButtonView(button: buttonImage)
                ButtonView(button: buttonImage2)
            }
        }
    }
}
