//
//  celdaVeterinarios.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 23/04/26.
//

import UIKit

class CeldaVeterinarios: UITableViewCell {
    
    
    @IBOutlet weak var lblNombres: UILabel!
    @IBOutlet weak var lblEspecialidad: UILabel!
    @IBOutlet weak var lblColegiatura: UILabel!
    @IBOutlet weak var imgVet: UIImageView!
    @IBOutlet weak var lblActivo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
