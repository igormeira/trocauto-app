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
        labelName.text = auto.name
        labelMC.text = "Custo mensal: R$ \(mc)"
        labelFuel.text = "Preço do combustível: R$ \(auto.fuelPrice)"
    }

}
