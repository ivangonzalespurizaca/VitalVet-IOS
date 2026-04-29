//
//  CeldaHorarios.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 24/04/26.
//

import UIKit

class CeldaHorarios: UITableViewCell {

    @IBOutlet weak var lblDiaHora: UILabel!
    @IBOutlet weak var lblEstado: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configurar(con horario: HorarioInfo) {
        // 1. Título con el día y la hora resaltada
        lblDiaHora.text = "\(horario.diaSemana.capitalized) • \(horario.horaInicio.prefix(5)) - \(horario.horaFin.prefix(5))"
        lblDiaHora.font = UIFont.boldSystemFont(ofSize: 15)
        
        // 2. Estilo del Badge para el Estado
        lblEstado.text = "  \(horario.activo ? "ACTIVO" : "INACTIVO")  "
        lblEstado.layer.cornerRadius = 6
        lblEstado.clipsToBounds = true
        lblEstado.font = UIFont.boldSystemFont(ofSize: 11)
        
        if horario.activo {
            lblEstado.textColor = .systemGreen
            lblEstado.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.12)
        } else {
            lblEstado.textColor = .systemRed
            lblEstado.backgroundColor = UIColor.systemRed.withAlphaComponent(0.12)
        }
    }

    private func setupEstiloTarjeta() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        
        // Sombra suave para dar profundidad
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.06
        contentView.layer.shadowRadius = 4
        contentView.layer.masksToBounds = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Esto crea la separación entre celdas (el "aire")
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
    }

}
