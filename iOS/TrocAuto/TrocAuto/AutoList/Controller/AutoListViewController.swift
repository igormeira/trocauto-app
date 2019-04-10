//
//  SecondViewController.swift
//  TrocAuto
//
//  Created by Igor Meira on 27/02/19.
//  Copyright © 2019 Igor Meira. All rights reserved.
//

import UIKit

class AutoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Outlets
    @IBOutlet weak var tableAuto: UITableView!
    
    //MARK: - Variables
    
    var listAuto : Array<Vehicle> = []
    var selectedVehicle : Vehicle?
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableAuto.dataSource = self
        tableAuto.delegate = self
        
        listAuto = VehicleDAO().getVehiclesAndAutos().vehicles
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reload()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editVehicle"){
            let autoData = segue.destination as! AddAutoViewController
            autoData.selectedAuto = self.selectedVehicle
        }
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listAuto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AutoListCell
        let auto = listAuto[indexPath.row]
        cell.configAutoCell(auto: auto)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let auto = listAuto[indexPath.row]
        Alert(controller: self).showDetails(auto.name, message: auto.details())
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let removeButton = UITableViewRowAction(style: .destructive, title: "Remover") { (rowAction, indexpath) in
            DispatchQueue.main.async {
                let selectedAuto = self.listAuto[indexPath.row]
                Alert(controller: self).showRemove(selectedAuto, handler : { action in
                    VehicleDAO().deleteAuto(selectedAuto)
                    self.reload()
                })
            }
        }
        
        let editButton = UITableViewRowAction(style: .normal, title: "Editar") { (rowAction, indexpath) in
            self.selectedVehicle = self.listAuto[indexPath.row]
            self.performSegue(withIdentifier: "editVehicle", sender: tableView.cellForRow(at: indexPath))
        }
        
        return [removeButton, editButton]
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? 105 : 150
    }
    
    //MARK: - Functions
    
    func reload() {
        listAuto = VehicleDAO().getVehiclesAndAutos().vehicles
        tableAuto.reloadData()
    }
    
}

