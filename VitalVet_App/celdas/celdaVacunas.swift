import UIKit

class celdaVacunas: UITableViewCell {

    @IBOutlet weak var txtveterinario: UILabel!
    @IBOutlet weak var txtnomvacuna: UILabel!
    @IBOutlet weak var txtEstado: UILabel!
    
    // Contenedor principal para el diseño de tarjeta
    private let cardView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func aplicarDiseno() {
        // 🛡️ El chequeo de seguridad que evita el "Fatal Error"
        guard txtnomvacuna != nil, txtveterinario != nil, txtEstado != nil else { return }

        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        txtnomvacuna.font = .systemFont(ofSize: 16, weight: .bold)
        txtnomvacuna.textColor = .darkGray
        
        txtveterinario.font = .systemFont(ofSize: 14, weight: .medium)
        txtveterinario.textColor = .gray
        
        txtEstado.font = .systemFont(ofSize: 12, weight: .bold)
        txtEstado.textAlignment = .center
        txtEstado.layer.cornerRadius = 6
        txtEstado.clipsToBounds = true
    }

    func actualizarEstado(estado: String) {
        // 🛡️ Seguridad extra
        guard txtEstado != nil else { return }
        
        txtEstado.text = " \(estado.uppercased()) "
        
        if estado.uppercased() == "APLICADA" {
            txtEstado.textColor = .systemGreen
            txtEstado.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        } else {
            txtEstado.textColor = .systemOrange
            txtEstado.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.1)
        }
    }
}
