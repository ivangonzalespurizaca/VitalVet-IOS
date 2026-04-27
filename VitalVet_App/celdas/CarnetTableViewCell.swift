//
//  CarnetTableViewCell.swift
//  VitalVet_App
//
//  Created by XCODE on 27/04/26.
//

import UIKit

class CarnetTableViewCell: UITableViewCell {

    @IBOutlet weak var txtEstado: UILabel!
    
    @IBOutlet weak var txtFecha: UILabel!
    @IBOutlet weak var txtnombre: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
