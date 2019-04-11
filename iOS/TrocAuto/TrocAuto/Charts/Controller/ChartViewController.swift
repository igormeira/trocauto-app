//
//  FirstViewController.swift
//  TrocAuto
//
//  Created by Igor Meira on 27/02/19.
//  Copyright © 2019 Igor Meira. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var fieldAuto1: UITextField!
    @IBOutlet weak var fieldAuto2: UITextField!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var slider: UISlider!
    
    // MARK: - Final Attributes
    let COLOR_PURPLE = NSUIColor.purple
    let COLOR_GREEN = NSUIColor.green
    
    // MARK: - Variables
    var autoPicker1 = UIPickerView()
    var autoPicker2 = UIPickerView()
    var listAuto : Array<Vehicle> = []
    var maxMonths : Int = 0
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        maxMonths = Int(slider.value)
        setChartValues()
        
        listAuto = VehicleDAO().getVehiclesAndAutos().vehicles
        
        autoPicker1.delegate = self
        autoPicker1.dataSource = self
        autoPicker1.tag = 1
        fieldAuto1.inputView = autoPicker1
        fieldAuto1.inputAccessoryView = setToolBar(self)
        
        autoPicker2.delegate = self
        autoPicker2.dataSource = self
        autoPicker2.tag = 2
        fieldAuto2.inputView = autoPicker2
        fieldAuto2.inputAccessoryView = setToolBar(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
        setChartValues()
    }

    //MARK: - Picker
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listAuto.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listAuto[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            fieldAuto1.text = listAuto[row].name
        } else {
            fieldAuto2.text = listAuto[row].name
        }
        setChartValues()
    }
    
    //MARK: - Slider
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        maxMonths = Int(sender.value)
        setChartValues()
    }
    
    //MARK: - Functions
    
    func reload() {
        listAuto = VehicleDAO().getVehiclesAndAutos().vehicles
    }
    
    func setChartValues() {
        var dataSets : Array<IChartDataSet> = []
        guard let v1 = fieldAuto1.text else {return}
        guard let v2 = fieldAuto2.text else {return}
        
        if let vehicle1 = VehicleDAO().getVehicleByName(v1) {
            slider.maximumValue = (Int(vehicle1.months) > Int(slider.maximumValue)) ? Float(vehicle1.months) : slider.maximumValue
            let set1 = getVehicleData(vehicle1, COLOR_PURPLE)
            dataSets.append(set1)
        }
        if let vehicle2 = VehicleDAO().getVehicleByName(v2) {
            slider.maximumValue = (Int(vehicle2.months) > Int(slider.maximumValue)) ? Float(vehicle2.months) : slider.maximumValue
            let set2 = getVehicleData(vehicle2, COLOR_GREEN)
            dataSets.append(set2)
        }
        
        let data = LineChartData.init(dataSets: dataSets)
        
        self.lineChartView.data = data
        
        self.lineChartView.chartDescription?.text = (dataSets.count > 0) ? "Dados em R$" : "Escolha um veículo"
        
    }
    
    func getVehicleData(_ vehicle : Vehicle, _ color : NSUIColor) -> LineChartDataSet {
        let mc = vehicle.calculateMonthlyCost()
        let listMC = vehicle.calculateAllMonthsCost(baseCost: mc)
        let max = (Int(vehicle.months) >= maxMonths) ? maxMonths : Int(vehicle.months)
        
        let values = (1..<max+1).map {(i) -> ChartDataEntry in
            let val = listMC[i-1]
            return ChartDataEntry(x: Double(i), y: val)
        }
        let set = LineChartDataSet(values: values, label: vehicle.name)
        set.colors = [color]
        set.circleColors = [color]
        
        return set
    }
    
}

