import UIKit
import Alamofire

class ProgramarcitaController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerVacunas: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtNroDosis: UITextField!
    @IBOutlet weak var txtObservaciones: UITextField!
    
    var id: Int? // ID de la mascota recibida
    var listaVacunas: [VacunaDisponible] = [] // Aquí guardaremos la respuesta de la API
    var vacunaSeleccionadaId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerVacunas.delegate = self
        pickerVacunas.dataSource = self
        
        // Cargamos las vacunas apenas abre la vista
        cargarCatalogoVacunas()
    }

    // MARK: - Cargar Datos de la API
    func cargarCatalogoVacunas() {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        
        let url = "https://apiveterinaria-production-238b.up.railway.app/api/vacunas"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "Accept": "application/json"]
        
        AF.request(url, headers: headers).responseDecodable(of: [VacunaDisponible].self) { response in
            switch response.result {
            case .success(let vacunas):
                self.listaVacunas = vacunas
            
                self.pickerVacunas.reloadAllComponents()
                
                // Opcional: Seleccionar el ID de la primera vacuna por defecto
                if let primeraVacuna = vacunas.first {
                    self.vacunaSeleccionadaId = primeraVacuna.idVacuna
                }
                
            case .failure(let error):
                print("Error cargando vacunas: \(error.localizedDescription)")
            }
        }
    }
    // MARK: - PickerView Config
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listaVacunas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listaVacunas[row].nombreVacuna
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        vacunaSeleccionadaId = listaVacunas[row].idVacuna
    }

    // MARK: - Registro Final (POST)
    @IBAction func btnGuardarProgramacion(_ sender: UIButton) {
        guard let idMascota = id, let idVacuna = vacunaSeleccionadaId else {
            print("Falta ID Mascota o Vacuna")
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let fechaStr = formatter.string(from: datePicker.date)
        
        // Construimos el body exacto que requiere tu API
        let parametros: [String: Any] = [
            "idVacuna": idVacuna,
            "nroDosis": Int(txtNroDosis.text ?? "1") ?? 1,
            "fechaProgramada": fechaStr,
            "observaciones": txtObservaciones.text ?? ""
        ]
        
        let urlPost = "https://apiveterinaria-production-238b.up.railway.app/api/vacunas-aplicadas/mascota/\(idMascota)/programar"
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(urlPost,
                   method: .post,
                   parameters: parametros,
                   encoding: JSONEncoding.default,
                   headers: headers,
        ).responseJSON { response in
            if response.response?.statusCode == 201 || response.response?.statusCode == 200 {
                self.alertExito()
            } else {
                print("Error al guardar: \(response.error?.localizedDescription ?? "Desconocido")")
            }
        }
    }
    
    func alertExito() {
        let alert = UIAlertController(title: "¡Listo!", message: "Vacuna programada", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}
