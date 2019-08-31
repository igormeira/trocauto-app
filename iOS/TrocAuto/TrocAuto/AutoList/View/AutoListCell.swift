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
    @IBOutlet weak var labelMC: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    func configAutoCell(auto:Vehicle) {
        let mc = auto.calculateMonthlyCost()
        let price = auto.initPrice
        
        Formatter.currency.locale = .br
        
        labelName.text = auto.name
        labelMC.text = "Custo mensal: \(mc.currency)"
        labelPrice.text = "Valor: \(price.currency)"
    }

}
