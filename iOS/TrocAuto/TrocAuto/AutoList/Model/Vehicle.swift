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
    var timeReview : Int32
    var kmReview : Double
    var reviewPrice : Double
    var ipva : Double
    var insurance : Double
    
    var reviewType : String
    
    //var reviewNumber : Int
    //var baseCost : Double
    //var monthlyCost : [Double]
    
    //MARK: - Init
    
    init(name:String, months:Int32, initPrice:Double, fuelPrice:Double, consumption:Double, kmMonth:Double, timeReview:Int32, kmReview:Double, reviewPrice:Double, reviewType:String, ipva:Double, insurance:Double) {
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
        self.ipva = ipva
        self.insurance = insurance
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
            let number = Double(months) / Double(timeReview)
            return Int(number.rounded(.down))
        }
    }
    
    func calculateTotalBaseCost() -> Double {
        let cost = Double(months) * (((kmMonth / consumption) * fuelPrice) + (insurance / 12.00))
        let addIpvaCost = (((Double(months) / 12.00)) * ipva) + cost
        let finalCost = (addIpvaCost*100.00).rounded()/100.00
        return finalCost
    }
    
    func calculateMonthlyCost() -> Double {
        let cost = (((kmMonth / consumption) * fuelPrice) + (insurance / 12.00))
        let finalCost = (cost*100.00).rounded()/100.00
        return finalCost
    }
    
    func calculateAllMonthsCost(baseCost : Double) -> [Double] {
        var costs : [Double] = []
        var cost = 0.00
        var m = 1
        var mIpva = 1
        switch reviewType {
        case "km":
            var km = 0.0
            while m <= months {
                km += kmMonth
                if km >= kmReview {
                    cost = (costs.count > 0) ? ((baseCost + reviewPrice) + costs.last!) : (baseCost + reviewPrice)
                    if (mIpva == 12) {
                        cost = cost + ipva
                        mIpva = 0
                    }
                    costs.append((cost*100).rounded()/100)
                }
                else {
                    cost = (costs.count > 0) ? (baseCost + costs.last!) : baseCost
                    if (mIpva == 12) {
                        cost = cost + ipva
                        mIpva = 0
                    }
                    costs.append(cost)
                }
                m = m + 1
                mIpva = mIpva + 1
            }
            return costs
        default:
            var toReview = 0
            while m <= months {
                toReview += 1
                if toReview == timeReview {
                    toReview = 0
                    cost = (costs.count > 0) ? ((baseCost + reviewPrice) + costs.last!) : (baseCost + reviewPrice)
                    if (mIpva == 12) {
                        cost = cost + ipva
                        mIpva = 0
                    }
                    costs.append((cost*100).rounded()/100)
                }
                else {
                    cost = (costs.count > 0) ? (baseCost + costs.last!) : baseCost
                    if (mIpva == 12) {
                        cost = cost + ipva
                        mIpva = 0
                    }
                    costs.append(cost)
                }
                m = m + 1
                mIpva = mIpva + 1
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
    
    func details() -> String {
        let message = "\nValor do veículo:\n\(initPrice.currency)\n\nGasto em \(months) meses (sem resvisões):\n\(calculateTotalBaseCost().currency)\n\nPreço do combustível:\n\(fuelPrice.currency)\n\nConsumo:\n\(Help().dotToComma(consumption)) Km/L\n\nPreço médio da revisão:\n\(reviewPrice.currency)\n\nIPVA:\n\(ipva.currency)\n\nSeguro:\n\(insurance.currency)"
        return message
    }
}
