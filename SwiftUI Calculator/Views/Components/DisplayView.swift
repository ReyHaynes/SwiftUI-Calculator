//
//  DisplayView.swift
//  SwiftUI Calculator
//
//  Created by Reinaldo Haynes on 7/26/20.
//

import SwiftUI

struct DisplayView: View {
    var content: String
    
    var contentFormatted: String {
        let formatter = NumberFormatter()
        let contentValue = Double(content)!
        let numberCeiling = 9999999999.9
        let numberFloor =  0.0000000001
        
        if (contentValue <= numberCeiling && contentValue >= numberFloor) ||
            content == CalculatorButton.zero.label {
            formatter.numberStyle = .decimal
            formatter.maximumIntegerDigits = 9
            formatter.maximumSignificantDigits = 9
        } else {
            formatter.numberStyle = .scientific
            formatter.maximumIntegerDigits = 3
            formatter.maximumSignificantDigits = 5
        }
        formatter.exponentSymbol = "e"
        
        return formatter
            .string(from: NSNumber(value: contentValue)) ?? "0"
    }
    
    var fontSize: CGFloat {
        switch contentFormatted.count {
        case 12...:
            return 53
        case 11:
            return 63
        case 10:
            return 66
        case 9:
            return 69
        case 8:
            return 75
        default:
            return 85
        }
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(contentFormatted)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .font(.system(size: fontSize))
            }
        }
        .frame(width: UIScreen.main.bounds.width - 20, height: 100)
    }
}

struct DisplayView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayView(content: "2345353533343836489932923299999999999.9")
    }
}
