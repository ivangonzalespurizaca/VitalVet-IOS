//
//  celdaVacunas.swift
//  VitalVet_App
//
//  Created by XCODE on 23/04/26.
//

import UIKit

class celdaVacunas: UITableViewCell {

    @IBOutlet weak var txtveterinario: UILabel!
    @IBOutlet weak var txtnomvacuna: UILabel!
    @IBOutlet weak var txtEstado: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
