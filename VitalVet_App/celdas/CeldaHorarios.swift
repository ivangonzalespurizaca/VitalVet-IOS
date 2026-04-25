//
//  CeldaHorarios.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 24/04/26.
//

import UIKit

class CeldaHorarios: UITableViewCell {

    @IBOutlet weak var lblDiaHora: UILabel!
    @IBOutlet weak var lblEstado: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
