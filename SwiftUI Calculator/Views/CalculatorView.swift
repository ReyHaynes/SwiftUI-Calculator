//
//  CalculatorView.swift
//  SwiftUI Calculator
//
//  Created by Reinaldo Haynes on 7/24/20.
//

import SwiftUI

struct CalculatorView: View {
    let buttons = CalculatorButton.layout.basic
    let sizing: ButtonSizing = ButtonSizing(spacing: 12)
    @ObservedObject var actions: CalculatorActions = CalculatorActions()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .trailing, spacing: sizing.spacing) {
                DisplayView(content: actions.displayContent)
                
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: sizing.spacing) {
                        ForEach(row, id: \.self) { button in
                            Button(action: {
                                actions.updateDisplay(button: button)
                            }, label: {
                                ButtonView(button: button, sizing: sizing)
                            })
                        }
                    }
                }
            }
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
