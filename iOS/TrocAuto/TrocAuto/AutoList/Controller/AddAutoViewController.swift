//
//  AddAutoViewController.swift
//  TrocAuto
//
//  Created by Igor Meira on 28/02/19.
//  Copyright © 2019 Igor Meira. All rights reserved.
//

import UIKit

class AddAutoViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var fieldName: UITextField!
    @IBOutlet weak var fieldMonths: UITextField!
    @IBOutlet weak var fieldInitValue: UITextField!
    @IBOutlet weak var fieldFuelPrice: UITextField!
    @IBOutlet weak var fieldConsumption: UITextField!
    @IBOutlet weak var fieldKmMonths: UITextField!
    @IBOutlet weak var fieldTimeReview: UITextField!
    @IBOutlet weak var fieldKmReview: UITextField!
    @IBOutlet weak var fieldReviewPrice: UITextField!
    @IBOutlet weak var segReviewType: UISegmentedControl!
    @IBOutlet weak var viewTitle: UILabel!
    
    //MARK: - Variables
    
    var segmentIndex = 0
    var selectedAuto : Vehicle?
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        
        segReviewType.addTarget(self, action: #selector(changeReviewType(_:)), for: .valueChanged)
        fillFields()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Functions
    
    func isValid() -> Bool {
        guard let _ = fieldName.text else {return false}
        guard let _ = fieldMonths.text else {return false}
        guard let _ = fieldInitValue.text else {return false}
        guard let _ = fieldFuelPrice.text else {return false}
        guard let _ = fieldConsumption.text else {return false}
        guard let _ = fieldKmMonths.text else {return false}
        guard let _ = fieldTimeReview.text else {return false}
        guard let _ = fieldKmReview.text else {return false}
        guard let _ = fieldReviewPrice.text else {return false}
        return true
    }
    
    func fillFields() {
        if let sAuto = selectedAuto {
            viewTitle.text = "EDITAR VEÍCULO"
            
            fieldName.text = sAuto.name
            fieldMonths.text = String(sAuto.months)
            fieldInitValue.text = String(sAuto.initPrice)
            fieldFuelPrice.text = String(sAuto.fuelPrice)
            fieldConsumption.text = String(sAuto.consumption)
            fieldKmMonths.text = String(sAuto.kmMonth)
            fieldTimeReview.text = String(sAuto.timeReview)
            fieldKmReview.text = String(sAuto.kmReview)
            fieldReviewPrice.text = String(sAuto.reviewPrice)
            if sAuto.reviewType == "Por Mês" {
                segmentIndex = 0
            } else {
                segmentIndex = 1
                segReviewType.selectedSegmentIndex = 1
            }
        } else {
            viewTitle.text = "ADICIONAR VEÍCULO"
        }
    }
    
    //MARK: - Actions
    
    @IBAction func back(_ sender: Any) {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        }
    }
    
    @IBAction func changeReviewType(_ sender: Any) {
        switch segmentIndex {
        case 1:
            segmentIndex = 0
        default:
            segmentIndex = 1
        }
    }
    
    @IBAction func save(_ sender: Any) {
        if isValid() {
            let dictionaryAuto : Dictionary<String, Any> = [
                "name" : fieldName.text!,
                "months" : Int32(fieldMonths.text!)!,
                "initial_price" : Double(fieldInitValue.text!)!,
                "fuel_price" : Double(fieldFuelPrice.text!)!,
                "consumption" : Double(fieldConsumption.text!)!,
                "km_months" : Double(fieldKmMonths.text!)!,
                "time_review" : Double(fieldTimeReview.text!)!,
                "km_review" : Double(fieldKmReview.text!)!,
                "price_review" : Double(fieldReviewPrice.text!)!,
                "review_type" : segReviewType.titleForSegment(at: segReviewType.selectedSegmentIndex)!
            ]
            if let sAuto = selectedAuto {
                VehicleDAO().updateAuto(name: sAuto.name, dictionaryVehicle: dictionaryAuto)
            } else {
                VehicleDAO().saveAuto(dictionaryVehicle: dictionaryAuto)
            }
            if let navigation = navigationController {
                navigation.popViewController(animated: true)
            }
        }
    }
}
