//
//  CompareViewController.swift
//  TrocAuto
//
//  Created by Igor Meira on 26/07/19.
//  Copyright © 2019 Igor Meira. All rights reserved.
//

import UIKit

class CompareViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var fieldVehicle1: UITextField!
    @IBOutlet weak var fieldVehicle2: UITextField!
    @IBOutlet weak var labelValueV1: UILabel!
    @IBOutlet weak var labelValueV2: UILabel!
    @IBOutlet weak var labelFuelV1: UILabel!
    @IBOutlet weak var labelFuelV2: UILabel!
    @IBOutlet weak var labelConsumptionV1: UILabel!
    @IBOutlet weak var labelConsumptionV2: UILabel!
    @IBOutlet weak var labelRTimeV1: UILabel!
    @IBOutlet weak var labelRTimeV2: UILabel!
    @IBOutlet weak var labelRKmV1: UILabel!
    @IBOutlet weak var labelRKmV2: UILabel!
    @IBOutlet weak var labelRPriceV1: UILabel!
    @IBOutlet weak var labelRPriceV2: UILabel!
    @IBOutlet weak var labelIPVAV1: UILabel!
    @IBOutlet weak var labelIPVAV2: UILabel!
    @IBOutlet weak var labelInsuranceV1: UILabel!
    @IBOutlet weak var labelInsuranceV2: UILabel!
    
    // MARK: - Variables
    var vehiclePicker1 = UIPickerView()
    var vehiclePicker2 = UIPickerView()
    var listVehicle : Array<Vehicle> = []
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        
        listVehicle = VehicleDAO().getVehiclesAndAutos().vehicles
        
        vehiclePicker1.delegate = self
        vehiclePicker1.dataSource = self
        vehiclePicker1.tag = 1
        fieldVehicle1.inputView = vehiclePicker1
        fieldVehicle1.inputAccessoryView = setToolBar(self)
        
        vehiclePicker2.delegate = self
        vehiclePicker2.dataSource = self
        vehiclePicker2.tag = 2
        fieldVehicle2.inputView = vehiclePicker2
        fieldVehicle2.inputAccessoryView = setToolBar(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
        setCompareValues()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Picker
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listVehicle.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listVehicle[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if listVehicle.count > 1 {
            if pickerView.tag == 1 {
                fieldVehicle1.text = listVehicle[row].name
            } else {
                fieldVehicle2.text = listVehicle[row].name
            }
            setCompareValues()
        }
        else {
            
        }
    }
    
    // MARK: - Functions
    
    func reload() {
        listVehicle = VehicleDAO().getVehiclesAndAutos().vehicles
    }
    
    func setCompareValues() {
        guard let v1 = fieldVehicle1.text else {return}
        guard let v2 = fieldVehicle2.text else {return}
        
        if let vehicle1 = VehicleDAO().getVehicleByName(v1) {
            labelValueV1.text = vehicle1.initPrice.currency
            labelFuelV1.text = vehicle1.fuelPrice.currency
            labelConsumptionV1.text = "\(Help().dotToComma(vehicle1.consumption)) Km/L"
            labelRTimeV1.text = "\(Int(vehicle1.timeReview)) Meses"
            labelRKmV1.text = "\(Int(vehicle1.kmReview)) Km"
            labelRPriceV1.text = vehicle1.reviewPrice.currency
            labelIPVAV1.text = vehicle1.ipva.currency
            labelInsuranceV1.text = vehicle1.insurance.currency
            
            let compareVehicle1 = vehicle1
            
            if let vehicle2 = VehicleDAO().getVehicleByName(v2) {
                labelValueV2.text = vehicle2.initPrice.currency
                labelFuelV2.text = vehicle2.fuelPrice.currency
                labelConsumptionV2.text = "\(Help().dotToComma(vehicle2.consumption)) Km/L"
                labelRTimeV2.text = "\(Int(vehicle2.timeReview)) Meses"
                labelRKmV2.text = "\(Int(vehicle2.kmReview)) Km"
                labelRPriceV2.text = vehicle2.reviewPrice.currency
                labelIPVAV2.text = vehicle2.ipva.currency
                labelInsuranceV2.text = vehicle2.insurance.currency
                
                let compareVehicle2 = vehicle2
                
                setResultColors(compareVehicle1, compareVehicle2)
            }
        }
        
    }
    
    func setResultColors(_ vehicle1 : Vehicle, _ vehicle2 : Vehicle) {
        priceColor(vehicle1, vehicle2)
        fuelColor(vehicle1, vehicle2)
        consumptionColor(vehicle1, vehicle2)
        reviewTimeColor(vehicle1, vehicle2)
        reviewKmColor(vehicle1, vehicle2)
        reviewPriceColor(vehicle1, vehicle2)
        ipvaColor(vehicle1, vehicle2)
        insuranceColor(vehicle1, vehicle2)
    }
    
    fileprivate func priceColor(_ vehicle1: Vehicle, _ vehicle2: Vehicle) {
        if vehicle1.initPrice > vehicle2.initPrice {
            labelValueV1.textColor = UIColor(named: "redColor")
            labelValueV2.textColor = UIColor(named: "greenColor")
        }
        else if vehicle1.initPrice < vehicle2.initPrice {
            labelValueV1.textColor = UIColor(named: "greenColor")
            labelValueV2.textColor = UIColor(named: "redColor")
        }
        else {
            labelValueV1.textColor = UIColor(named: "blueColor")
            labelValueV2.textColor = UIColor(named: "blueColor")
        }
    }
    
    fileprivate func fuelColor(_ vehicle1: Vehicle, _ vehicle2: Vehicle) {
        if vehicle1.fuelPrice > vehicle2.fuelPrice {
            labelFuelV1.textColor = UIColor(named: "redColor")
            labelFuelV2.textColor = UIColor(named: "greenColor")
        }
        else if vehicle1.fuelPrice < vehicle2.fuelPrice {
            labelFuelV1.textColor = UIColor(named: "greenColor")
            labelFuelV2.textColor = UIColor(named: "redColor")
        }
        else {
            labelFuelV1.textColor = UIColor(named: "blueColor")
            labelFuelV2.textColor = UIColor(named: "blueColor")
        }
    }
    
    fileprivate func consumptionColor(_ vehicle1: Vehicle, _ vehicle2: Vehicle) {
        if vehicle1.consumption > vehicle2.consumption {
            labelConsumptionV1.textColor = UIColor(named: "greenColor")
            labelConsumptionV2.textColor = UIColor(named: "redColor")
        }
        else if vehicle1.consumption < vehicle2.consumption {
            labelConsumptionV1.textColor = UIColor(named: "redColor")
            labelConsumptionV2.textColor = UIColor(named: "greenColor")
        }
        else {
            labelConsumptionV1.textColor = UIColor(named: "blueColor")
            labelConsumptionV2.textColor = UIColor(named: "blueColor")
        }
    }
    
    fileprivate func reviewTimeColor(_ vehicle1: Vehicle, _ vehicle2: Vehicle) {
        if vehicle1.timeReview > vehicle2.timeReview {
            labelRTimeV1.textColor = UIColor(named: "redColor")
            labelRTimeV2.textColor = UIColor(named: "greenColor")
        }
        else if vehicle1.timeReview < vehicle2.timeReview {
            labelRTimeV1.textColor = UIColor(named: "greenColor")
            labelRTimeV2.textColor = UIColor(named: "redColor")
        }
        else {
            labelRTimeV1.textColor = UIColor(named: "blueColor")
            labelRTimeV2.textColor = UIColor(named: "blueColor")
        }
    }
    
    fileprivate func reviewKmColor(_ vehicle1: Vehicle, _ vehicle2: Vehicle) {
        if vehicle1.kmReview > vehicle2.kmReview {
            labelRKmV1.textColor = UIColor(named: "greenColor")
            labelRKmV2.textColor = UIColor(named: "redColor")
        }
        else if vehicle1.kmReview < vehicle2.kmReview {
            labelRKmV1.textColor = UIColor(named: "redColor")
            labelRKmV2.textColor = UIColor(named: "greenColor")
        }
        else {
            labelRKmV1.textColor = UIColor(named: "blueColor")
            labelRKmV2.textColor = UIColor(named: "blueColor")
        }
    }
    
    fileprivate func reviewPriceColor(_ vehicle1: Vehicle, _ vehicle2: Vehicle) {
        if vehicle1.reviewPrice > vehicle2.reviewPrice {
            labelRPriceV1.textColor = UIColor(named: "redColor")
            labelRPriceV2.textColor = UIColor(named: "greenColor")
        }
        else if vehicle1.reviewPrice < vehicle2.reviewPrice {
            labelRPriceV1.textColor = UIColor(named: "greenColor")
            labelRPriceV2.textColor = UIColor(named: "redColor")
        }
        else {
            labelRPriceV1.textColor = UIColor(named: "blueColor")
            labelRPriceV2.textColor = UIColor(named: "blueColor")
        }
    }
    
    fileprivate func ipvaColor(_ vehicle1: Vehicle, _ vehicle2: Vehicle) {
        if vehicle1.ipva > vehicle2.ipva {
            labelIPVAV1.textColor = UIColor(named: "redColor")
            labelIPVAV2.textColor = UIColor(named: "greenColor")
        }
        else if vehicle1.ipva < vehicle2.ipva {
            labelIPVAV1.textColor = UIColor(named: "greenColor")
            labelIPVAV2.textColor = UIColor(named: "redColor")
        }
        else {
            labelIPVAV1.textColor = UIColor(named: "blueColor")
            labelIPVAV2.textColor = UIColor(named: "blueColor")
        }
    }
    
    fileprivate func insuranceColor(_ vehicle1: Vehicle, _ vehicle2: Vehicle) {
        if vehicle1.insurance > vehicle2.insurance {
            labelInsuranceV1.textColor = UIColor(named: "redColor")
            labelInsuranceV2.textColor = UIColor(named: "greenColor")
        }
        else if vehicle1.insurance < vehicle2.insurance {
            labelInsuranceV1.textColor = UIColor(named: "greenColor")
            labelInsuranceV2.textColor = UIColor(named: "redColor")
        }
        else {
            labelInsuranceV1.textColor = UIColor(named: "blueColor")
            labelInsuranceV2.textColor = UIColor(named: "blueColor")
        }
    }
    
}
