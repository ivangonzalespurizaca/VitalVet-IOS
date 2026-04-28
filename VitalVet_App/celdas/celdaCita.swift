//
//  celdaCita.swift
//  VitalVet_App
//
//  Created by XCODE on 28/04/26.
//

import UIKit
import Kingfisher

class celdaCita: UITableViewCell {
    
    
    @IBOutlet weak var imgMascota: UIImageView!
    
    @IBOutlet weak var lblNombreMascota: UILabel!
    
    @IBOutlet weak var lblNombreCliente: UILabel!
    
    
    @IBOutlet weak var txtMotivo: UITextView!
    
    @IBOutlet weak var lblCelular: UILabel!
    
    @IBOutlet weak var lblFechaHora: UILabel!
    
    @IBOutlet weak var viewEstado: UIView!
    
    @IBOutlet weak var lblEstado: UILabel!
    
    @IBOutlet weak var btnAprobar: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Si mide 22x22, el radio 11 lo hace un círculo perfecto
        viewEstado.layer.cornerRadius = viewEstado.frame.height / 2
                viewEstado.clipsToBounds = true
                btnAprobar.layer.cornerRadius = 8
                
                // Esto ayuda a que el botón reciba el toque dentro de la celda
                contentView.bringSubviewToFront(btnAprobar)
    }
    
    var funcionAprobar: (() -> Void)?

        func configurar(con cita: CitaInfo) {
            lblNombreMascota.text = "Mascota: \(cita.nombreMascota)"
            lblNombreCliente.text = "Dueño: \(cita.nombreCliente)"
            lblCelular.text = "Celular: \(cita.celularCliente)"
            txtMotivo.text = "Motivo: \(cita.motivo)"
            lblFechaHora.text = " \(cita.fecha)   \(cita.hora)"
            lblEstado.text = cita.estado
            
            // Cargar imagen de la mascota
            if let urlString = cita.fotoMascotaUrl, let url = URL(string: urlString) {
                // DESCOMENTA ESTO:
                imgMascota.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_mascota"))
            } else {
                imgMascota.image = UIImage(named: "placeholder_mascota")
            }

            // Lógica de colores por estado
            configurarBadge(estado: cita.estado)
            
            // El veterinario solo aprueba lo que está PENDIENTE
            btnAprobar.isHidden = (cita.estado != "PENDIENTE")
        }
    
    private func configurarBadge(estado: String) {
            viewEstado.layer.cornerRadius = 8
            switch estado {
            case "PENDIENTE":
                viewEstado.backgroundColor = .systemOrange
            
            case "CONFIRMADA":
                viewEstado.backgroundColor = .systemGreen
      
            case "COMPLETADA":
                viewEstado.backgroundColor = .systemBlue
     
            default:
                viewEstado.backgroundColor = .systemGray
    
            }
        }
        
        @IBAction func btnAprobarTapped(_ sender: Any) {
            print("Botón presionado en la celda")
            funcionAprobar?()
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
