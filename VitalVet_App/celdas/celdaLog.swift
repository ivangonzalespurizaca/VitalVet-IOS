//
//  celdaLog.swift
//  VitalVet_App
//
//  Created by XCODE on 27/04/26.
//

import UIKit

class celdaLog: UITableViewCell {
    
   
    @IBOutlet weak var lblDescripcion: UITextView!
    
    @IBOutlet weak var lblUsuario: UILabel!
    
    @IBOutlet weak var lblTabla: UILabel!
    
    @IBOutlet weak var lblAccion: UILabel!
    
    @IBOutlet weak var lblFecha: UILabel!

    

    override func awakeFromNib() {
        super.awakeFromNib()
                // FUNCIONALIDAD: Esto permite que la celda calcule su altura según el texto
                lblDescripcion?.isScrollEnabled = false
                lblDescripcion?.isEditable = false
    }
    
    func configurar(con log: LogDTO) {
        // Usamos "?" para evitar el crash si el Outlet no está conectado
                lblDescripcion?.text = log.descripcion
                
                let nombre = log.nombreUsuario ?? "SISTEMA"
                let rol = log.rolUsuario ?? "N/A"
                lblUsuario?.text = "Por: \(nombre) - \(rol)"
                
                lblTabla?.text = "Módulo: \(log.tablaAfectada)"
                lblAccion?.text = log.accion
                
        lblAccion?.backgroundColor = .clear
                lblAccion?.textColor = .black
                lblFecha?.text = formatearFecha(log.fechaRegistro)
        }

    private func formatearFecha(_ cadena: String) -> String {
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            if let date = isoFormatter.date(from: cadena) {
                let df = DateFormatter()
                df.dateFormat = "dd/MM/yy HH:mm"
                return df.string(from: date)
            }
            return String(cadena.prefix(16)).replacingOccurrences(of: "T", with: " ")
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
