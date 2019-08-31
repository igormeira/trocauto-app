//
//  StringExtension.swift
//  TrocAuto
//
//  Created by Igor Meira on 28/07/19.
//  Copyright © 2019 Igor Meira. All rights reserved.
//

import Foundation

extension String {
    
    func prepareCurrencyToSave() -> Double? {
        let response = self.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "R$ ", with: "").replacingOccurrences(of: ",", with: ".")
        return Double(response)
    }
    
    func prepareConsumptionToSave() -> Double? {
        let response = self.replacingOccurrences(of: ",", with: ".")
        return Double(response)
    }
    
    func prepareKmToSave() -> Double? {
        let response = Double(self)
        return response
    }
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "R$ "
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
}
