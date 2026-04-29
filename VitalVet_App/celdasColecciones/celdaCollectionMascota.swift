//
//  celdaCollectionMascota.swift
//  VitalVet_App
//
//  Created by XCODE on 23/04/26.
//

import UIKit

class celdaCollectionMascota: UICollectionViewCell {
    
    @IBOutlet weak var txtRaza: UILabel!
    @IBOutlet weak var txtespecie: UILabel!
    @IBOutlet weak var txtnombreMascota: UILabel!
    @IBOutlet weak var imgmascota: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configurarDisenoTarjeta()
    }
    
    private func configurarDisenoTarjeta() {
        // 1. Bordes redondeados y sombra para la celda
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 6
        self.backgroundColor = .white
        
        // 2. Estilo de la Imagen
        imgmascota.layer.cornerRadius = 12
        imgmascota.contentMode = .scaleAspectFill
        imgmascota.clipsToBounds = true
        
        // 3. Estilo de Textos
        txtnombreMascota.font = .systemFont(ofSize: 18, weight: .bold)
        txtespecie.textColor = .systemBlue
        txtespecie.font = .systemFont(ofSize: 14, weight: .semibold)
        txtRaza.textColor = .darkGray
        txtRaza.font = .systemFont(ofSize: 13, weight: .regular)
    }
}
