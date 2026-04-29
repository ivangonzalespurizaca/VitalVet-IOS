import UIKit
import Kingfisher

class celdaCita: UITableViewCell {
    
    @IBOutlet weak var imgMascota: UIImageView!
    @IBOutlet weak var lblNombreMascota: UILabel!
    @IBOutlet weak var lblNombreCliente: UILabel!
    @IBOutlet weak var lblMotivo: UILabel! // Cambiado a UILabel para mejor rendimiento
    @IBOutlet weak var lblCelular: UILabel!
    @IBOutlet weak var lblFechaHora: UILabel!
    @IBOutlet weak var viewEstado: UIView!
    @IBOutlet weak var lblEstado: UILabel!
    @IBOutlet weak var btnAprobar: UIButton!
    
    var funcionAprobar: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 1. Estilo de la imagen (Círculo con borde)
        imgMascota.layer.cornerRadius = imgMascota.frame.height / 2
        imgMascota.layer.borderWidth = 2
        imgMascota.layer.borderColor = UIColor.systemGray6.cgColor
        imgMascota.clipsToBounds = true
        
        // 2. Estilo de la Tarjeta
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        
        // 3. Estilo del Botón Aprobar
        btnAprobar.layer.cornerRadius = 10
        btnAprobar.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        
        // 4. Tipografías
        lblNombreMascota.font = .systemFont(ofSize: 18, weight: .bold)
        lblNombreCliente.font = .systemFont(ofSize: 14, weight: .medium)
        lblNombreCliente.textColor = .darkGray
        lblCelular.font = .systemFont(ofSize: 13, weight: .regular)
        lblCelular.textColor = .systemBlue
        
        lblMotivo.font = .systemFont(ofSize: 13, weight: .regular)
        lblMotivo.textColor = .gray
        lblMotivo.numberOfLines = 2 // Permite que el motivo se vea un poco más
        
        lblFechaHora.font = .systemFont(ofSize: 12, weight: .semibold)
        lblFechaHora.textColor = .secondaryLabel
    }

    func configurar(con cita: CitaInfo) {
        lblNombreMascota.text = cita.nombreMascota.capitalized
        lblNombreCliente.text = "Dueño: \(cita.nombreCliente)"
        lblCelular.text = " \(cita.celularCliente)"
        lblMotivo.text = "“\(cita.motivo)”"
        lblFechaHora.text = " \(cita.fecha)  at \(cita.hora)"
        lblEstado.text = cita.estado
        
        // Imagen con Kingfisher
        if let urlStr = cita.fotoMascotaUrl, let url = URL(string: urlStr.replacingOccurrences(of: "http://", with: "https://")) {
            imgMascota.kf.setImage(with: url, placeholder: UIImage(named: "placeholder_mascota"))
        } else {
            imgMascota.image = UIImage(systemName: "pawprint.circle.fill")
        }

        configurarBadge(estado: cita.estado)
        btnAprobar.isHidden = (cita.estado != "PENDIENTE")
    }
    
    private func configurarBadge(estado: String) {
        viewEstado.layer.cornerRadius = 6
        lblEstado.font = .systemFont(ofSize: 10, weight: .black)
        
        switch estado {
        case "PENDIENTE":
            viewEstado.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)
            lblEstado.textColor = .systemOrange
        case "CONFIRMADA":
            viewEstado.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
            lblEstado.textColor = .systemGreen
        case "COMPLETADA":
            viewEstado.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.15)
            lblEstado.textColor = .systemBlue
        default:
            viewEstado.backgroundColor = UIColor.systemGray.withAlphaComponent(0.15)
            lblEstado.textColor = .systemGray
        }
    }

    @IBAction func btnAprobarTapped(_ sender: Any) {
        funcionAprobar?()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Crear el efecto de tarjeta separada
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        
        // Sombra suave para la tarjeta
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 3)
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 5
        contentView.layer.masksToBounds = false
    }
}
