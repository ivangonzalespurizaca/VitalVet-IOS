//
//  celdaVacuna.swift
//  VitalVet_App
//
//  Created by XCODE on 25/04/26.
//

import UIKit

class celdaVacuna: UITableViewCell {

    @IBOutlet weak var lblVacuna: UILabel!
    
    @IBOutlet weak var lblFechaAplicacion: UILabel!
    
    @IBOutlet weak var lblFechaProgramada: UILabel!
    
    @IBOutlet weak var lblNroDosis: UILabel!
    
    @IBOutlet weak var lblEstado: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        }
    
    // Este método se puede utilizar para formatear la fecha correctamente
        func configurarFechaProgramada(fecha: String?) {
            if let fechaProgramada = fecha, !fechaProgramada.isEmpty {
                // Formatear la fecha si está disponible
                lblFechaProgramada.text = "Fecha Programada: \(fechaProgramada)"
            } else {
                // Si no hay fecha programada, mostrar "No Programada"
                lblFechaProgramada.text = "Fecha Programada: No Programada"
            }
        }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
