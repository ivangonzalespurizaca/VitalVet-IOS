//
//  CeldaCitas.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 26/04/26.
//

import UIKit

class CeldaCitas: UITableViewCell {
    
    @IBOutlet weak var lblMascota: UILabel!
    @IBOutlet weak var lblFechaHora: UILabel!
    @IBOutlet weak var lblVeterinario: UILabel!
    @IBOutlet weak var lblEstado: UILabel!
    @IBOutlet weak var imgMascota: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
