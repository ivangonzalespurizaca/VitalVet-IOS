//
//  ConsultaCollectionViewCell.swift
//  VitalVet_App
//
//  Created by XCODE on 27/04/26.
//

import UIKit

class ConsultaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblMascota: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblDiagnostico: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let colorTarjeta = UIColor(red: 0.94, green: 0.96, blue: 1.0, alpha: 1.0)
            
        contentView.backgroundColor = colorTarjeta
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        // Sombra suave para dar profundidad
        self.backgroundColor = .clear
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.08
        contentView.layer.masksToBounds = false // Permite que la sombra se vea
        
        // 2. Estilo de los Textos
        // Nombre de la mascota: Fuerte y destacado
        lblMascota.font = .systemFont(ofSize: 18, weight: .bold)
        lblMascota.textColor = .darkText
        
        // Fecha: Un poco más pequeña y profesional
        lblFecha.font = .systemFont(ofSize: 14, weight: .semibold)
        lblFecha.textColor = .systemBlue // Color de énfasis
        
        // Diagnóstico: Cuerpo de texto legible
        lblDiagnostico.font = .systemFont(ofSize: 13, weight: .regular)
        lblDiagnostico.textColor = .secondaryLabel
        lblDiagnostico.numberOfLines = 0 // Asegura las múltiples líneas
        lblDiagnostico.textAlignment = .left
        
        // 3. Estilo de la Imagen
        img.layer.cornerRadius = img.frame.height / 2
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.backgroundColor = .systemGray6 // Fondo por si no carga la imagen
    }
    
    // Función para llenar los datos desde el ViewController
    func configurar(mascota: String, fecha: String, diagnostico: String, imagenNombre: String) {
        lblMascota.text = mascota
        lblFecha.text = fecha
        lblDiagnostico.text = diagnostico
        img.image = UIImage(named: imagenNombre) ?? UIImage(systemName: "pawprint.fill")
    }
    
    // Este método ayuda a que la celda mantenga su forma al reciclarse
    override func prepareForReuse() {
        super.prepareForReuse()
        img.image = nil
    }
}
