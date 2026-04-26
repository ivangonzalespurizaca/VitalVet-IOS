//
//  celdaConsulta.swift
//  VitalVet_App
//
//  Created by XCODE on 25/04/26.
//

import UIKit

class celdaConsulta: UITableViewCell {
    
    @IBOutlet weak var lblDiagnostico: UILabel!
    
    @IBOutlet weak var lblFecha: UILabel!

    @IBOutlet weak var btnOpciones: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.masksToBounds = true
            
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        
        self.contentView.backgroundColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
