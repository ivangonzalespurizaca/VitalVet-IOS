import UIKit

class CeldaHorariosDisponibles: UITableViewCell {
    
    @IBOutlet weak var lblFechaHora: UILabel!
    
    // Vista contenedora para dar el efecto de "tarjeta" o cápsula
    private let containerView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        configurarDiseno()
    }

    private func configurarDiseno() {
        // 1. Quitar el color gris feo de selección
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        // 2. Configurar el Label
        lblFechaHora.font = .systemFont(ofSize: 14, weight: .medium)
        lblFechaHora.textColor = .darkGray
        
        // 3. Estilo de "Cápsula" (Opcional si quieres que parezca un botón)
        // Si prefieres algo más minimalista, solo asegúrate de que el texto
        // tenga un buen espaciado.
    }

    // Este método lo llamarás desde el cellForRowAt
    func configurar(texto: String) {
        // Agregamos un icono de reloj al texto para que se vea más profesional
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "clock")?.withTintColor(.systemBlue)
        let imageString = NSMutableAttributedString(attachment: attachment)
        
        let textString = NSAttributedString(string: "  \(texto)")
        imageString.append(textString)
        
        lblFechaHora.attributedText = imageString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // 4. Feedback visual al tocar
        if selected {
            UIView.animate(withDuration: 0.2) {
                self.lblFechaHora.textColor = .systemBlue
                self.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.lblFechaHora.textColor = .darkGray
                self.transform = .identity
            }
        }
    }
}
