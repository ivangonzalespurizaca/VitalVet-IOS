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
    
    @IBOutlet weak var imgVacuna: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgVacuna.image = UIImage(named: "vacuna")
        imgVacuna.contentMode = .scaleAspectFit
        imgVacuna.layer.cornerRadius = imgVacuna.frame.height / 2
        imgVacuna.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
