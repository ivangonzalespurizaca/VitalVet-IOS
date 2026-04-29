import UIKit
import Kingfisher

class CeldaVeterinarios: UITableViewCell {

    @IBOutlet weak var lblNombres: UILabel!
    @IBOutlet weak var lblEspecialidad: UILabel!
    @IBOutlet weak var lblColegiatura: UILabel!
    @IBOutlet weak var imgVet: UIImageView!
    @IBOutlet weak var lblActivo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 1. Círculo Perfecto (Mitad de 60)
        imgVet.layer.cornerRadius = 30
        imgVet.clipsToBounds = true
        imgVet.contentMode = .scaleAspectFill
        imgVet.layer.borderWidth = 1.5
        imgVet.layer.borderColor = UIColor.systemGray6.cgColor
        
        // 2. Estilo de tarjeta
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
        
        // 3. Estilo de los Labels (Tipografía mejorada)
        lblNombres.font = .systemFont(ofSize: 15, weight: .semibold)
        lblNombres.textColor = .black
        
        lblEspecialidad.font = .systemFont(ofSize: 14, weight: .medium)
        lblEspecialidad.textColor = .systemBlue // Color de marca
        
        lblColegiatura.font = .systemFont(ofSize: 13, weight: .regular)
        lblColegiatura.textColor = .darkGray
        
        // 4. Badge del estado
        lblActivo.layer.cornerRadius = 6
        lblActivo.clipsToBounds = true
        lblActivo.font = .systemFont(ofSize: 10, weight: .black)
    }

    func configurar(con vet: VeterinarioInfo) {
        // 1. Nombres y Especialidad formateada
        lblNombres.text = "\(vet.nombres) \(vet.apellidos)".capitalized
        lblEspecialidad.text = vet.especialidad.replacingOccurrences(of: "_", with: " ").capitalized
        lblColegiatura.text = "Colegiatura: \(vet.numColegiatura)"
        
        // 2. Manejo del estado (Badge)
        let estaActivo = vet.activo ?? false
        if estaActivo {
            lblActivo.text = "  ACTIVO   "
            lblActivo.textColor = .systemGreen
            lblActivo.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.12)
        } else {
            lblActivo.text = "  INACTIVO   "
            lblActivo.textColor = .systemRed
            lblActivo.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        }
        
        // 3. Carga de imagen con Kingfisher
        if var urlStr = vet.fotoUrl {
            // Corrección de seguridad http -> https
            if urlStr.hasPrefix("http://") {
                urlStr = urlStr.replacingOccurrences(of: "http://", with: "https://")
            }
            
            let url = URL(string: urlStr)
            imgVet.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person.crop.circle.fill"),
                options: [.transition(.fade(0.2))]
            )
        } else {
            imgVet.image = UIImage(systemName: "person.crop.circle.fill")
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Margen para el efecto de tarjetas
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        
        // Sombra sutil para la tarjeta
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.08
        contentView.layer.shadowRadius = 4
        contentView.layer.masksToBounds = false
    }
}
