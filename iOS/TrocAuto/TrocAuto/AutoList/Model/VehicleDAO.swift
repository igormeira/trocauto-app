//
//  VehicleDAO.swift
//  TrocAuto
//
//  Created by Igor Meira on 28/02/19.
//  Copyright © 2019 Igor Meira. All rights reserved.
//

import UIKit
import CoreData

class VehicleDAO: NSObject {
    
    //MARK: - Variables
    
    var gerenciadorDeResultados:NSFetchedResultsController<Auto>?
    var context:NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    //MARK: - Methods
    
    func getVehiclesAndAutos() -> (vehicles: Array<Vehicle>, autos: Array<Auto>) {
        let searchAuto:NSFetchRequest<Auto> = Auto.fetchRequest()
        let orderByName = NSSortDescriptor(key: "name", ascending: true)
        searchAuto.sortDescriptors = [orderByName]
        
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: searchAuto, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try gerenciadorDeResultados?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        guard let listAuto = gerenciadorDeResultados?.fetchedObjects else { return ([], []) }
        let listVehicle = getVehicles(listAuto)
        
        return (listVehicle, listAuto)
    }
    
    func getVehicles(_ listAuto : Array<Auto>) -> Array<Vehicle> {
        var vehicles : Array<Vehicle> = []
        
        for auto in listAuto {
            guard let rt = auto.review_type else {return vehicles}
            let vehicle = Vehicle(name: auto.name!, months: auto.months, initPrice: auto.initial_price, fuelPrice: auto.fuel_price, consumption: auto.consumption, kmMonth: auto.km_months, timeReview: auto.time_review, kmReview: auto.km_review, reviewPrice: auto.price_review, reviewType: rt)
            vehicles.append(vehicle)
        }
        
        return vehicles
    }
    
    func saveAuto(dictionaryVehicle:Dictionary<String, Any>) {
        var auto:NSManagedObject?
        
        let entity = NSEntityDescription.entity(forEntityName: "Auto", in: context)
        auto = NSManagedObject(entity: entity!, insertInto: context)
        
        auto?.setValue(dictionaryVehicle["name"] as? String, forKey: "name")
        auto?.setValue(dictionaryVehicle["months"], forKey: "months")
        auto?.setValue(dictionaryVehicle["initial_price"], forKey: "initial_price")
        auto?.setValue(dictionaryVehicle["fuel_price"], forKey: "fuel_price")
        auto?.setValue(dictionaryVehicle["consumption"], forKey: "consumption")
        auto?.setValue(dictionaryVehicle["km_months"], forKey: "km_months")
        auto?.setValue(dictionaryVehicle["time_review"], forKey: "time_review")
        auto?.setValue(dictionaryVehicle["km_review"], forKey: "km_review")
        auto?.setValue(dictionaryVehicle["price_review"], forKey: "price_review")
        auto?.setValue(dictionaryVehicle["review_type"] as? String, forKey: "review_type")
        
        updateContext()
    }
    
    func updateAuto(name: String, dictionaryVehicle:Dictionary<String, Any>) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Auto")
        request.predicate = NSPredicate(format: "name = %@", name)
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                let auto = result[0] as AnyObject
                auto.setValue(dictionaryVehicle["name"] as? String, forKey: "name")
                auto.setValue(dictionaryVehicle["months"], forKey: "months")
                auto.setValue(dictionaryVehicle["initial_price"], forKey: "initial_price")
                auto.setValue(dictionaryVehicle["fuel_price"], forKey: "fuel_price")
                auto.setValue(dictionaryVehicle["consumption"], forKey: "consumption")
                auto.setValue(dictionaryVehicle["km_months"], forKey: "km_months")
                auto.setValue(dictionaryVehicle["time_review"], forKey: "time_review")
                auto.setValue(dictionaryVehicle["km_review"], forKey: "km_review")
                auto.setValue(dictionaryVehicle["price_review"], forKey: "price_review")
                auto.setValue(dictionaryVehicle["review_type"] as? String, forKey: "review_type")
                
                updateContext()
            }
        } catch {
            print("Failed")
        }
    }
    
    func deleteAuto(_ vehicle:Vehicle) {
        let autos = self.getVehiclesAndAutos().autos
        for auto in autos {
            if (auto.name == vehicle.name) && (auto.months == vehicle.months) {
                context.delete(auto)
                break
            }
        }
        updateContext()
    }
    
    func getVehicleByName(_ name:String) -> Vehicle? {
        let vehicles = getVehiclesAndAutos().vehicles
        for v in vehicles {
            if v.name == name {
                return v
            }
        }
        return nil
    }
    
    func updateContext() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

