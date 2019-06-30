//
//  Auto.swift
//  TrocAuto
//
//  Created by Igor Meira on 28/02/19.
//  Copyright © 2019 Igor Meira. All rights reserved.
//

import Foundation

class Vehicle: NSObject {
    
    //MARK: - Variables
    
    var name : String
    var months : Int32
    var initPrice : Double
    var fuelPrice : Double
    var consumption : Double
    var kmMonth : Double
    var timeReview : Double
    var kmReview : Double
    var reviewPrice : Double
    
    var reviewType : String
    
    //var reviewNumber : Int
    //var baseCost : Double
    //var monthlyCost : [Double]
    
    //MARK: - Init
    
    init(name:String, months:Int32, initPrice:Double, fuelPrice:Double, consumption:Double, kmMonth:Double, timeReview:Double, kmReview:Double, reviewPrice:Double, reviewType:String) {
        self.name = name
        self.months = months
        self.initPrice = initPrice
        self.fuelPrice = fuelPrice
        self.consumption = consumption
        self.kmMonth = kmMonth
        self.timeReview = timeReview
        self.kmReview = kmReview
        self.reviewPrice = reviewPrice
        self.reviewType = reviewType
    }
    
    //MARK: - Functions
    
    func calculateReviewNumber() -> Int {
        switch reviewType {
        case "km":
            var km = 0.0
            var number = 0
            for _ in 1...months {
                km += kmMonth
                if km >= kmReview {
                    number += 1
                }
            }
            return number
        default:
            let number = Double(months) / timeReview
            return Int(number.rounded(.down))
        }
    }
    
    func calculateTotalBaseCost() -> Double {
        let cost = Double(months) * ((kmMonth / consumption) * fuelPrice)
        let finalCost = (cost*100).rounded()/100
        return finalCost
    }
    
    func calculateMonthlyCost() -> Double {
        let cost = ((kmMonth / consumption) * fuelPrice)
        let finalCost = (cost*100).rounded()/100
        return finalCost
    }
    
    func calculateAllMonthsCost(baseCost : Double) -> [Double] {
        var costs : [Double] = []
        var cost = 0.00
        var i = 1
        switch reviewType {
        case "km":
            var km = 0.0
            while i <= months {
                km += kmMonth
                if km >= kmReview {
                    cost = (costs.count > 0) ? ((baseCost + reviewPrice) + costs.last!) : (baseCost + reviewPrice)
                    costs.append((cost*100).rounded()/100)
                }
                else {
                    cost = (costs.count > 0) ? (baseCost + costs.last!) : baseCost
                    costs.append(cost)
                }
                i = i + 1
            }
            return costs
        default:
            var toReview = 0.0
            while i <= months {
                toReview += 1.0
                if toReview == timeReview {
                    toReview = 0.0
                    cost = (costs.count > 0) ? ((baseCost + reviewPrice) + costs.last!) : (baseCost + reviewPrice)
                    costs.append((cost*100).rounded()/100)
                }
                else {
                    cost = (costs.count > 0) ? (baseCost + costs.last!) : baseCost
                    costs.append(cost)
                }
                i = i + 1
            }
            return costs
        }
    }
    
    static func ==(first:Vehicle, second:Vehicle) -> Bool{
        if first.name == second.name {
            return true
        }
        else {
            return false
        }
    }
    
    func changeCommaToDot (_ double : Double) -> String {
        var doubleStr = String(format:"%.2f", double)
        doubleStr = doubleStr.replacingOccurrences(of: ".", with: ",")
        return doubleStr
    }
    
    func details() -> String {
        let message = "Valor de entrada: R$\(changeCommaToDot(initPrice)) \n Gasto em \(months) meses: R$\(changeCommaToDot(calculateTotalBaseCost())) \n Gasto mensal: R$\(changeCommaToDot(calculateMonthlyCost())) \n Revisão: R$\(changeCommaToDot(reviewPrice)) \n Tipo de revisão: \(reviewType)"
        return message
    }
}
