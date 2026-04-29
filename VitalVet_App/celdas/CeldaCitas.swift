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
        configurarImagen()
    }
    
    private func configurarImagen() {
        // 1. Redondeo total (Círculo)
        // Para que sea un círculo perfecto, el Width y Height en el Storyboard deben ser iguales
        imgMascota.layer.cornerRadius = imgMascota.frame.height / 2
        
        // 2. Importante: Recortar el contenido para que respete el redondeo
        imgMascota.clipsToBounds = true
        
        // 3. Ajuste de contenido (Para que no se vea estirada)
        imgMascota.contentMode = .scaleAspectFill
        
        // 4. Opcional: Agregar un borde fino para que resalte
        imgMascota.layer.borderWidth = 1.0
        imgMascota.layer.borderColor = UIColor.systemGray5.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
