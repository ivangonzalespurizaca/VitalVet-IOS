//
//  CeldaCollectionSlotHorario.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 26/04/26.
//

import UIKit

class CeldaCollectionSlotHorario: UICollectionViewCell {
   
    @IBOutlet weak var lblHora: UILabel!
   
    override func awakeFromNib() {
            super.awakeFromNib()
            self.layer.cornerRadius = 8
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.systemGray5.cgColor
            self.backgroundColor = .systemGray6
        
        lblHora.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                lblHora.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
                lblHora.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
                lblHora.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
                lblHora.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
            ])
        }
    
    func configurarSeleccion(estaSeleccionado: Bool, esDisponible: Bool) {
        if !esDisponible {
            // Estado: No disponible (Gris oscuro y bloqueado)
            self.backgroundColor = .systemGray4
            lblHora.textColor = .systemGray
            self.isUserInteractionEnabled = false // Evita que se pueda tocar
        } else if estaSeleccionado {
            // Estado: Seleccionado
            self.backgroundColor = .systemBlue
            lblHora.textColor = .white
            self.isUserInteractionEnabled = true
        } else {
            // Estado: Disponible pero no seleccionado
            self.backgroundColor = .systemGray6
            lblHora.textColor = .black
            self.isUserInteractionEnabled = true
        }
    }
    
}
