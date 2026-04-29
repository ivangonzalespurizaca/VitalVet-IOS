import UIKit
import Kingfisher

class celdaMascotaxdni: UITableViewCell {
    
    @IBOutlet weak var txtnombre: UILabel!
    @IBOutlet weak var txtEspecie: UILabel!
    @IBOutlet weak var txtraza: UILabel!
    @IBOutlet weak var imgMascota: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configurarDisenoInicial()
    }
    
    private func configurarDisenoInicial() {
        // 1. Imagen Circular Perfecta
        imgMascota.layer.cornerRadius = 40
        imgMascota.clipsToBounds = true
        imgMascota.contentMode = .scaleAspectFill
        imgMascota.layer.borderWidth = 1.2
        imgMascota.layer.borderColor = UIColor.systemGray6.cgColor
        
        // 2. Estilo de Tarjeta (Fondo blanco y bordes)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
        
        // 3. Tipografía con Jerarquía
        txtnombre.font = .systemFont(ofSize: 17, weight: .bold)
        txtnombre.textColor = .black
        
        txtEspecie.font = .systemFont(ofSize: 14, weight: .medium)
        txtEspecie.textColor = .systemBlue
        
        txtraza.font = .systemFont(ofSize: 13, weight: .regular)
        txtraza.textColor = .darkGray
        
        self.selectionStyle = .none
    }
    
    func configurarDatos(con mascota: Mascota) {
        txtnombre.text = mascota.nombreMascota.capitalized
        txtEspecie.text = mascota.especie.capitalized
        txtraza.text = mascota.raza.capitalized
        
        // --- MANEJO DE IMAGEN CON SEGURIDAD HTTPS ---
        
        // 1. Creamos una variable local basada en el valor que ya existe
        var urlStr = mascota.fotoUrl
        
        // 2. Corrección de seguridad (esto ahora funcionará sin problemas)
        if urlStr.hasPrefix("http://") {
            urlStr = urlStr.replacingOccurrences(of: "http://", with: "https://")
        }
        
        // 3. Verificamos que la URL sea válida antes de pasarla a Kingfisher
        if let url = URL(string: urlStr) {
            imgMascota.kf.indicatorType = .activity
            imgMascota.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "pawprint.circle.fill"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        } else {
            // Si la URL está mal formada, ponemos el placeholder
            imgMascota.image = UIImage(systemName: "pawprint.circle.fill")
            imgMascota.tintColor = .systemGray4
        }
        
        func layoutSubviews() {
            super.layoutSubviews()
            // 4. Margen para crear el efecto de "celdas separadas"
            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
            
            // 5. Sombra para que la tarjeta "flote"
            contentView.layer.shadowColor = UIColor.black.cgColor
            contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
            contentView.layer.shadowOpacity = 0.06
            contentView.layer.shadowRadius = 4
            contentView.layer.masksToBounds = false
        }
    }
}
