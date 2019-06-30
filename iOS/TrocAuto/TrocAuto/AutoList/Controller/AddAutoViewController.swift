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
        
        fieldName.inputAccessoryView = setToolBar(self)
        fieldMonths.inputAccessoryView = setToolBar(self)
        fieldInitValue.inputAccessoryView = setToolBar(self)
        fieldFuelPrice.inputAccessoryView = setToolBar(self)
        fieldConsumption.inputAccessoryView = setToolBar(self)
        fieldKmMonths.inputAccessoryView = setToolBar(self)
        fieldTimeReview.inputAccessoryView = setToolBar(self)
        fieldKmReview.inputAccessoryView = setToolBar(self)
        fieldReviewPrice.inputAccessoryView = setToolBar(self)
        
        fillFields()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Functions
    
    func isValid() -> Bool {
        guard let name = fieldName.text else {return false}
        guard let months = fieldMonths.text else {return false}
        guard let initValue = fieldInitValue.text else {return false}
        guard let fuelPrice = fieldFuelPrice.text else {return false}
        guard let consumption = fieldConsumption.text else {return false}
        guard let kmMonths = fieldKmMonths.text else {return false}
        guard let timeReview = fieldTimeReview.text else {return false}
        guard let kmReview = fieldKmReview.text else {return false}
        guard let reviewPrice = fieldReviewPrice.text else {return false}
        
        if (name == "") || (months == "") || (initValue == "") || (fuelPrice == "") || (consumption == "") || (kmMonths == "") || (timeReview == "") || (kmReview == "") || (reviewPrice == "") {
            return false
        }
        
        return true
    }
    
    func fillFields() {
        if let sAuto = selectedAuto {
            viewTitle.text = "EDITAR VEÍCULO"
            
            fieldName.text = sAuto.name
            fieldMonths.text = String(sAuto.months).replacingOccurrences(of: ".", with: ",")
            fieldInitValue.text = String(sAuto.initPrice).replacingOccurrences(of: ".", with: ",")
            fieldFuelPrice.text = String(sAuto.fuelPrice).replacingOccurrences(of: ".", with: ",")
            fieldConsumption.text = String(sAuto.consumption).replacingOccurrences(of: ".", with: ",")
            fieldKmMonths.text = String(sAuto.kmMonth).replacingOccurrences(of: ".", with: ",")
            fieldTimeReview.text = String(sAuto.timeReview).replacingOccurrences(of: ".", with: ",")
            fieldKmReview.text = String(sAuto.kmReview).replacingOccurrences(of: ".", with: ",")
            fieldReviewPrice.text = String(sAuto.reviewPrice).replacingOccurrences(of: ".", with: ",")
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
    
    func changeCommaToDot (_ str : UITextField) -> String {
        guard let responseStr = str.text else { return "0.0" }
        return responseStr.replacingOccurrences(of: ",", with: ".")
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
            guard let name = fieldName.text else { return }
            guard let months = fieldMonths.text else { return }
            
            let dictionaryAuto : Dictionary<String, Any> = [
                "name" : name,
                "months" : Int32(months) ?? 0,
                "initial_price" : Double(changeCommaToDot(fieldInitValue)) ?? 0.0,
                "fuel_price" : Double(changeCommaToDot(fieldFuelPrice)) ?? 0.0,
                "consumption" : Double(changeCommaToDot(fieldConsumption)) ?? 0.0,
                "km_months" : Double(changeCommaToDot(fieldKmMonths)) ?? 0.0,
                "time_review" : Double(changeCommaToDot(fieldTimeReview)) ?? 0.0,
                "km_review" : Double(changeCommaToDot(fieldKmReview)) ?? 0.0,
                "price_review" : Double(changeCommaToDot(fieldReviewPrice)) ?? 0.0,
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
        else {
            Alert(controller : self).showDetails("Atenção", message: "Preencha todos os campos!")
        }
    }
}
