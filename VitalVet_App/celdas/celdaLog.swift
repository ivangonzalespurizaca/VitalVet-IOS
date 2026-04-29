//
//  celdaLog.swift
//  VitalVet_App
//
//  Created by XCODE on 27/04/26.
//

import UIKit

class celdaLog: UITableViewCell {
    
   
    @IBOutlet weak var lblDescripcion: UILabel!
    
    @IBOutlet weak var lblUsuario: UILabel!
    
    @IBOutlet weak var lblTabla: UILabel!
    
    @IBOutlet weak var lblAccion: UILabel!
    
    @IBOutlet weak var lblFecha: UILabel!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 1. IMPORTANTE: Permite infinitas líneas
        lblDescripcion.numberOfLines = 0
        
        // 2. Ajuste de línea por palabras
        lblDescripcion.lineBreakMode = .byWordWrapping
        
        lblUsuario.numberOfLines = 0 // Permite las líneas necesarias
        lblUsuario.lineBreakMode = .byWordWrapping
    }
    
    func configurar(con log: LogDTO) {
        
        // 1. Datos básicos
        lblDescripcion?.text = log.descripcion

        let nombre = log.nombreUsuario?.capitalized ?? "SISTEMA"
        let rol = log.rolUsuario ?? "N/A"

        // Creamos un texto con dos estilos diferentes
        let textoCompleto = NSMutableAttributedString(
            string: "Por \(nombre)\n",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 15), .foregroundColor: UIColor.black]
        )

        let textoRol = NSAttributedString(
            string: rol,
            attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.darkGray]
        )

        textoCompleto.append(textoRol)

        lblUsuario?.attributedText = textoCompleto
        lblUsuario?.numberOfLines = 0
        
        lblTabla?.text = "Módulo: \(log.tablaAfectada)"
        lblFecha?.text = formatearFecha(log.fechaRegistro)
        
        // 2. Lógica de Colores para el "Acción" (Badge)
        lblAccion?.text = "  \(log.accion)  "
        lblAccion?.layer.cornerRadius = 6
        lblAccion?.clipsToBounds = true
        lblAccion?.font = UIFont.boldSystemFont(ofSize: 12)
        
        configurarEstiloAccion(log.accion)
        
        // 3. Estilo de Tarjeta (Aplica esto al fondo de la celda o a un view contenedor)
        self.backgroundColor = .clear // La celda es transparente
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.masksToBounds = false
        
        // Sombra sutil
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.contentView.layer.shadowOpacity = 0.05
        self.contentView.layer.shadowRadius = 4
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
    
    private func configurarEstiloAccion(_ accion: String?) {
        guard let accion = accion else { return }
        
        switch accion {
        case "REGISTRO":
            lblAccion?.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.15)
            lblAccion?.textColor = .systemBlue
        case "ACTUALIZACION":
            lblAccion?.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)
            lblAccion?.textColor = .systemOrange
        case "ELIMINACION":
            lblAccion?.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
            lblAccion?.textColor = .systemRed
        default:
            lblAccion?.backgroundColor = .systemGray6
            lblAccion?.textColor = .darkGray
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
