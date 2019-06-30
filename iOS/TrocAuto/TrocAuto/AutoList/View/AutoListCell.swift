//
//  AutoListCell.swift
//  TrocAuto
//
//  Created by Igor Meira on 28/02/19.
//  Copyright © 2019 Igor Meira. All rights reserved.
//

import UIKit

class AutoListCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelFuel: UILabel!
    @IBOutlet weak var labelMC: UILabel!
    
    func configAutoCell(auto:Vehicle) {
        let mc = auto.calculateMonthlyCost()
        var mcStr = String(format:"%.2f", mc)
        mcStr = mcStr.replacingOccurrences(of: ".", with: ",")
        
        var fuelStr = String(format:"%.2f", auto.fuelPrice)
        fuelStr = fuelStr.replacingOccurrences(of: ".", with: ",")
        
        labelName.text = auto.name
        labelMC.text = "Custo mensal: R$ \(mcStr)"
        labelFuel.text = "Preço do combustível: R$ \(fuelStr)"
    }

}
