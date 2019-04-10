//
//  alertRemove.swift
//  TrocAuto
//
//  Created by Igor Meira on 03/04/19.
//  Copyright © 2019 Igor Meira. All rights reserved.
//

import Foundation
import UIKit

class Alert{
    let controller:UIViewController
    init(controller:UIViewController) {
        self.controller = controller
    }
    
    func showRemove(_ vehicle:Vehicle, handler: @escaping (UIAlertAction) -> Void) {
        
        let details = UIAlertController(title: vehicle.name, message: vehicle.details(), preferredStyle: UIAlertController.Style.alert)
        
        let remove = UIAlertAction(title: "Remove", style: UIAlertAction.Style.destructive, handler: handler)
        details.addAction(remove)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        details.addAction(cancel)
        
        controller.present(details, animated: true, completion: nil)
    }
    
    func showDetails(_ title:String = "Sorry", message:String = "Unexpected error.") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        controller.present(alert, animated: true, completion: nil)
    }
}
