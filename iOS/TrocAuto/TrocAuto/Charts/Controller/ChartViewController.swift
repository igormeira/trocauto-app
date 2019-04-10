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
    
    // MARK: - Variables
    var autoPicker1 = UIPickerView()
    var autoPicker2 = UIPickerView()
    var listAuto : Array<Vehicle> = []
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    //MARK: - Functions
    
    func reload() {
        listAuto = VehicleDAO().getVehiclesAndAutos().vehicles
    }
    
    func setChartValues() {
        if let v1 = fieldAuto1.text {
            guard let vehicle1 = VehicleDAO().getVehicleByName(v1) else {return}
            let mc = vehicle1.calculateMonthlyCost()
            let listMC = vehicle1.calculateAllMonthsCost(baseCost: mc)
            let values = (1..<7).map {(i) -> ChartDataEntry in
                let val = listMC[i-1]
                return ChartDataEntry(x: Double(i), y: val)
            }
            let set1 = LineChartDataSet(values: values, label: vehicle1.name)
            set1.colors = [NSUIColor.purple]
            set1.circleColors = [NSUIColor.purple]
            let data = LineChartData(dataSet: set1)
            
            self.lineChartView.data = data
            
            self.lineChartView.chartDescription?.text = "Dados em R$"
            
        } else {
            self.lineChartView.chartDescription?.text = "Dados insulficientes!"
        }
    }
    
}

