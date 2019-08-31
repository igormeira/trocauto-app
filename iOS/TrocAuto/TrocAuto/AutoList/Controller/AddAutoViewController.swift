//
//  AddAutoViewController.swift
//  TrocAuto
//
//  Created by Igor Meira on 28/02/19.
//  Copyright © 2019 Igor Meira. All rights reserved.
//

import UIKit

class AddAutoViewController: UIViewController, UITextFieldDelegate {
    
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
    @IBOutlet weak var fieldIPVA: UITextField!
    @IBOutlet weak var fieldCarInsurance: UITextField!
    
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    //MARK: - Variables
    
    var segmentIndex = 0
    var selectedAuto : Vehicle?
    
    var amountInitValue = 0
    var amountFuelPrice = 0
    var amountConsumption = 0
    var amountKmMonths = 0
    var amountKmReview = 0
    var amountReviewPrice = 0
    var amountIpva = 0
    var amountCarInsurance = 0
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        
        segReviewType.addTarget(self, action: #selector(changeReviewType(_:)), for: .valueChanged)
        
        fieldInitValue.delegate = self
        fieldFuelPrice.delegate = self
        fieldConsumption.delegate = self
        fieldKmMonths.delegate = self
        fieldKmReview.delegate = self
        fieldReviewPrice.delegate = self
        fieldIPVA.delegate = self
        fieldCarInsurance.delegate = self
        
        setKeyboardDone()
        keyboardNotifications()
        
        fillFields()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Keyboard
    
    @objc func keyboardWillShow(_ sender: NSNotification) {
        let i = sender.userInfo!
        let k = (i[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        bottomConstraint.constant = k - (self.view.safeAreaInsets.bottom - 5)
        let s: TimeInterval = (i[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animate(withDuration: s) { self.view.layoutIfNeeded() }
    }
    
    @objc func keyboardWillHide(_ sender: NSNotification) {
        let info = sender.userInfo!
        let s: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        bottomConstraint.constant = 0
        UIView.animate(withDuration: s) { self.view.layoutIfNeeded() }
    }
    
    func keyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIApplication.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIApplication.keyboardWillHideNotification,
                                               object: nil)
    }
    
    fileprivate func setKeyboardDone() {
        fieldName.inputAccessoryView = setToolBar(self)
        fieldMonths.inputAccessoryView = setToolBar(self)
        fieldInitValue.inputAccessoryView = setToolBar(self)
        fieldFuelPrice.inputAccessoryView = setToolBar(self)
        fieldConsumption.inputAccessoryView = setToolBar(self)
        fieldKmMonths.inputAccessoryView = setToolBar(self)
        fieldTimeReview.inputAccessoryView = setToolBar(self)
        fieldKmReview.inputAccessoryView = setToolBar(self)
        fieldReviewPrice.inputAccessoryView = setToolBar(self)
        fieldIPVA.inputAccessoryView = setToolBar(self)
        fieldCarInsurance.inputAccessoryView = setToolBar(self)
    }
    
    //MARK: - TextField onChange
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == fieldInitValue {
            if let digit = Int(string) {
                amountInitValue = amountInitValue * 10 + digit
                fieldInitValue.text = Help().updateAmountCurrency(amount: amountInitValue)
            }
            if string == "" {
                amountInitValue = amountInitValue / 10
                fieldInitValue.text = Help().updateAmountCurrency(amount: amountInitValue)
            }
        }
        else if textField == fieldFuelPrice {
            if let digit = Int(string) {
                amountFuelPrice = amountFuelPrice * 10 + digit
                fieldFuelPrice.text = Help().updateAmountCurrency(amount: amountFuelPrice)
            }
            if string == "" {
                amountFuelPrice = amountFuelPrice / 10
                fieldFuelPrice.text = Help().updateAmountCurrency(amount: amountFuelPrice)
            }
        }
        else if textField == fieldConsumption {
            if let digit = Int(string) {
                amountConsumption = amountConsumption * 10 + digit
                fieldConsumption.text = Help().updateAmountCurrency(amount: amountConsumption)
            }
            if string == "" {
                amountConsumption = amountConsumption / 10
                fieldConsumption.text = Help().updateAmountCurrency(amount: amountConsumption)
            }
        }
        else if textField == fieldKmMonths {
            if let digit = Int(string) {
                amountKmMonths = amountKmMonths * 10 + digit
                fieldKmMonths.text = Help().updateAmount(amount: amountKmMonths)
            }
            if string == "" {
                amountKmMonths = amountKmMonths / 10
                fieldKmMonths.text = Help().updateAmount(amount: amountKmMonths)
            }
        }
        else if textField == fieldKmReview {
            if let digit = Int(string) {
                amountKmReview = amountKmReview * 10 + digit
                fieldKmReview.text = Help().updateAmount(amount: amountKmReview)
            }
            if string == "" {
                amountKmReview = amountKmReview / 10
                fieldKmReview.text = Help().updateAmount(amount: amountKmReview)
            }
        }
        else if textField == fieldReviewPrice {
            if let digit = Int(string) {
                amountReviewPrice = amountReviewPrice * 10 + digit
                fieldReviewPrice.text = Help().updateAmountCurrency(amount: amountReviewPrice)
            }
            if string == "" {
                amountReviewPrice = amountReviewPrice / 10
                fieldReviewPrice.text = Help().updateAmountCurrency(amount: amountReviewPrice)
            }
        }
        else if textField == fieldIPVA {
            if let digit = Int(string) {
                amountIpva = amountIpva * 10 + digit
                fieldIPVA.text = Help().updateAmountCurrency(amount: amountIpva)
            }
            if string == "" {
                amountIpva = amountIpva / 10
                fieldIPVA.text = Help().updateAmountCurrency(amount: amountIpva)
            }
        }
        else if textField == fieldCarInsurance {
            if let digit = Int(string) {
                amountCarInsurance = amountCarInsurance * 10 + digit
                fieldCarInsurance.text = Help().updateAmountCurrency(amount: amountCarInsurance)
            }
            if string == "" {
                amountCarInsurance = amountCarInsurance / 10
                fieldCarInsurance.text = Help().updateAmountCurrency(amount: amountCarInsurance)
            }
        }
        
        return false
    }
    
    //MARK: - Functions
    
    func isValid() -> Bool {
        if (fieldName.text == "") || (fieldMonths.text == "") || (fieldInitValue.text == "") || (fieldFuelPrice.text == "") || (fieldConsumption.text == "") || (fieldKmMonths.text == "") || (fieldTimeReview.text == "") || (fieldTimeReview.text == "") || (fieldKmReview.text == "") || (fieldIPVA.text == "") || (fieldCarInsurance.text == "") {
            return false
        }
        
        return true
    }
    
    func fillFields() {
        if let sAuto = selectedAuto {
            viewTitle.text = "EDITAR VEÍCULO"
            
            fieldName.text = sAuto.name
            fieldMonths.text = String(sAuto.months)
            fieldTimeReview.text = String(sAuto.timeReview)
            
            fieldInitValue.text = String(sAuto.initPrice.currency).replacingOccurrences(of: "R$", with: "")
            amountInitValue = Int(sAuto.initPrice * 100.00)
            
            fieldFuelPrice.text = String(sAuto.fuelPrice.currency).replacingOccurrences(of: "R$", with: "")
            amountFuelPrice = Int(sAuto.fuelPrice * 100.00)
            
            fieldConsumption.text = String(sAuto.consumption.currency).replacingOccurrences(of: "R$", with: "")
            amountConsumption = Int(sAuto.consumption * 100.00)
            
            fieldKmMonths.text = Help().updateAmount(amount: Int(sAuto.kmMonth))
            amountKmMonths = Int(sAuto.kmMonth)
            
            fieldKmReview.text = Help().updateAmount(amount: Int(sAuto.kmReview))
            amountKmReview = Int(sAuto.kmReview)
            
            fieldReviewPrice.text = String(sAuto.reviewPrice.currency).replacingOccurrences(of: "R$", with: "")
            amountReviewPrice = Int(sAuto.reviewPrice * 100.00)
            
            fieldIPVA.text = String(sAuto.ipva.currency).replacingOccurrences(of: "R$", with: "")
            amountIpva = Int(sAuto.ipva * 100.00)
            
            fieldCarInsurance.text = String(sAuto.insurance.currency).replacingOccurrences(of: "R$", with: "")
            amountCarInsurance = Int(sAuto.insurance * 100.00)
            
            if sAuto.reviewType == "Por Mês" {
                segmentIndex = 0
            } else {
                segmentIndex = 1
                segReviewType?.selectedSegmentIndex = 1
            }
        } else {
            viewTitle.text = "ADICIONAR VEÍCULO"
        }
    }
    
    fileprivate func save(_ dictionaryAuto: [String : Any]) {
        if let sAuto = selectedAuto {
            VehicleDAO().updateAuto(name: sAuto.name, dictionaryVehicle: dictionaryAuto)
        } else {
            VehicleDAO().saveAuto(dictionaryVehicle: dictionaryAuto)
        }
    }
    
    fileprivate func backScreen() {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
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
            guard let name = fieldName.text else { return }
            guard let months = fieldMonths.text else { return }
            guard let timeReview = fieldTimeReview.text else { return }
            guard let reviewType = segReviewType else { return }
            
            let initValue = Help().prepareToSave(amount: amountInitValue, currency: true)
            let fuelPrice = Help().prepareToSave(amount: amountFuelPrice, currency: true)
            let consumption = Help().prepareToSave(amount: amountConsumption, currency: true)
            let kmMonths = Help().prepareToSave(amount: amountKmMonths, currency: false)
            let kmReview = Help().prepareToSave(amount: amountKmReview, currency: false)
            let priceReview = Help().prepareToSave(amount: amountReviewPrice, currency: true)
            let ipva = Help().prepareToSave(amount: amountIpva, currency: true)
            let insurance = Help().prepareToSave(amount: amountCarInsurance, currency: true)
            
            let rtStr = reviewType.titleForSegment(at: reviewType.selectedSegmentIndex)!
            
            let dictionaryAuto = Help().prepareDict(name, months, initValue, fuelPrice, consumption, kmMonths, timeReview, kmReview, priceReview, rtStr, ipva, insurance)
            
            save(dictionaryAuto)
            
            backScreen()
        }
        else {
            Alert(controller : self).showDetails("Atenção", message: "Preencha todos os campos!")
        }
    }
}
