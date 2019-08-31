//
//  Help.swift
//  TrocAuto
//
//  Created by Igor Meira on 27/07/19.
//  Copyright © 2019 Igor Meira. All rights reserved.
//

import Foundation

class Help {
    
    func dotToComma(_ value : Double) -> String {
        let str = String(format: "%.2f", value).replacingOccurrences(of: ".", with: ",")
        return str
    }
    
    func commaToDot(_ value : String) -> Double {
        if value.contains(",") {
            guard let response = Double(value.replacingOccurrences(of: ",", with: ".")) else {return 0.00}
            return response
        }
        else {
            guard let response = Double(value) else {return 0.00}
            return response
        }
    }
    
    func updateAmountCurrency(amount : Int) -> String? {
        Formatter.currency.locale = .br
        let finalAmount = Double(amount/100) + Double(amount%100)/100
        return finalAmount.currency.replacingOccurrences(of: "R$", with: "")
    }
    
    func updateAmount(amount : Int) -> String? {
        Formatter.currency.locale = .br
        let finalAmountStr = amount.currency.replacingOccurrences(of: "R$", with: "")
        let sub = finalAmountStr.prefix(finalAmountStr.count - 3)
        return String(sub)
    }
    
    func prepareToSave(amount : Int, currency: Bool) -> String {
        if let amountAux = currency == true ? updateAmountCurrency(amount: (amount)) : updateAmount(amount: (amount)) {
            Formatter.currency.locale = .br
            let finalAmountStr = amountAux.replacingOccurrences(of: "R$", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")
            let sub = finalAmountStr.suffix(finalAmountStr.count - 1)
            return String(sub)
        }
        else {
            return ""
        }
    }
    
    func prepareDict(_ name: String, _ months: String, _ initial_price: String, _ fuel_price: String, _ consumption: String, _ km_months: String, _ time_review: String, _ km_review: String, _ price_review: String, _ review_type: String, _ ipva: String, _ insurance: String) -> Dictionary<String, Any> {
        let dictionaryAuto : Dictionary<String, Any> = [
            "name" : name,
            "months" : Int32(months) ?? 0,
            "initial_price" : Double(initial_price) ?? 0.00,
            "fuel_price" : Double(fuel_price) ?? 0.00,
            "consumption" : Double(consumption) ?? 0.00,
            "km_months" : Double(km_months) ?? 0.00,
            "time_review" : Int32(time_review) ?? 0,
            "km_review" : Double(km_review) ?? 0.00,
            "price_review" : Double(price_review) ?? 0.00,
            "review_type" : review_type,
            "ipva" : Double(ipva) ?? 0.00,
            "insurance" : Double(insurance) ?? 0.00
        ]
        return dictionaryAuto
    }
    
}
