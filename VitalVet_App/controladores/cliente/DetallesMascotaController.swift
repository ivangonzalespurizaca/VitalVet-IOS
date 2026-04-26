import UIKit
import Alamofire

class DetallesMascotaController: UIViewController {
    
    // Outlets (Conéctalos en tu Storyboard)
    @IBOutlet weak var lblNombreVacuna: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblDosis: UILabel!
    @IBOutlet weak var lblEstado: UILabel!
    @IBOutlet weak var lblVeterinario: UILabel!
    @IBOutlet weak var txtObservaciones: UITextView! // Tu "Text Area"
    @IBOutlet weak var txtDescripcion: UITextView!  // Otro "Text Area"

    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchVacunaDetalle()
    }
    
    func setupUI() {
        
        [txtObservaciones, txtDescripcion].forEach { tv in
            tv?.layer.cornerRadius = 8
            tv?.layer.backgroundColor = UIColor.systemGray6.cgColor
            tv?.isEditable = false // Para que sea solo lectura
        }
    }
    
    func fetchVacunaDetalle() {
        
        guard let idSeguro = self.id else {
                print("❌ Error: ID de mascota no encontrado.")
                return
            }
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
                print("❌ Error: No hay token de seguridad.")
                return
            }
        let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Accept": "application/json"
            ]
        
        let url = "https://apiveterinaria-production-238b.up.railway.app/api/vacunas-aplicadas/mascota/\(idSeguro)/carnet"
        
        AF.request(url,headers: headers).responseDecodable(of: [VacunaElement].self) { response in
            switch response.result {
            case .success(let vacunas):
                if let detalle = vacunas.first {
                    self.updateUI(with: detalle)
                }
            case .failure(let error):
                print("Error al cargar: \(error)")
            }
        }
    }
    
    func updateUI(with vacuna: VacunaElement) {
        lblNombreVacuna.text = vacuna.nombreVacuna
        lblFecha.text = "\(vacuna.fechaAplicacion)"
        lblDosis.text = "\(vacuna.nroDosis)"
        lblEstado.text = vacuna.estado
        lblVeterinario.text = "Vet. \(vacuna.nombreVeterinario)"
        txtObservaciones.text = vacuna.observaciones
        txtDescripcion.text = vacuna.descripcionVacuna
        lblEstado.textColor = (vacuna.estado == "APLICADA") ? .systemGreen : .systemOrange
    }
}
