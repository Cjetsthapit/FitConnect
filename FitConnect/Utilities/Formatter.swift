//
//  Formatter.swift
//  FitConnect
//
//  Created by Srijeet Sthapit on 2024-02-15.
//

import Foundation

extension Double{
    func formattedString() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = . decimal
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
