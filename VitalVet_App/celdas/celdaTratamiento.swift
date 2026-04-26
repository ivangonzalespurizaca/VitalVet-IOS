//
//  celdaTratamiento.swift
//  VitalVet_App
//
//  Created by XCODE on 25/04/26.
//

import UIKit

class celdaTratamiento: UITableViewCell {
    
    
    @IBOutlet weak var lblMedicamemto: UILabel!
    
    @IBOutlet weak var lblDosis: UILabel!
    
    @IBOutlet weak var lblFrecuencia: UILabel!
    
    @IBOutlet weak var lblDuracionDias: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Configurar el estilo de las celdas
        let labels = [lblMedicamemto, lblDosis, lblFrecuencia, lblDuracionDias]
        
        // Configurar las etiquetas para permitir múltiples líneas
        for label in labels {
            label?.numberOfLines = 0
            label?.textAlignment = .left
            label?.lineBreakMode = .byWordWrapping
        }
        
        // Fondo suave y bordes redondeados para la celda
        contentView.backgroundColor = UIColor(named: "LightGreen")  // Color suave
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
