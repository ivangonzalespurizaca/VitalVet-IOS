import UIKit
import Alamofire

class ProgramarcitaController: UIViewControllerProfile, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerVacunas: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtNroDosis: UITextField!
    @IBOutlet weak var txtObservaciones: UITextField!
    
    var id: Int? // ID de la mascota recibida
    var listaVacunas: [VacunaDisponible] = [] // Aquí guardaremos la respuesta de la API
    var vacunaSeleccionadaId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        cambiarTitulo(nuevoTexto: "Programar Vacuna")
        pickerVacunas.delegate = self
        pickerVacunas.dataSource = self
        txtNroDosis.configurarEstiloVitalVet(icono: "list.number", placeholder: "Nro de Dosis")
        txtObservaciones.configurarEstiloVitalVet(icono: "note.text", placeholder: "Observaciones")
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
        // 1. Validaciones de IDs y Token
            guard let idMascota = id,
                  let idVacuna = vacunaSeleccionadaId,
                  let token = UserDefaults.standard.string(forKey: "userToken") else {
                alertError(mensaje: "No se pudo identificar la mascota o la sesión ha expirado.")
                return
            }
            
            // 2. Validación de campos de texto
            guard let dosisText = txtNroDosis.text, !dosisText.isEmpty else {
                alertError(mensaje: "Por favor, ingresa el número de dosis.")
                return
            }

            // 3. Formatear Fecha
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let fechaStr = formatter.string(from: datePicker.date)

            // 4. Preparar Diccionario
            let parametros: [String: Any] = [
                "idVacuna": idVacuna,
                "nroDosis": Int(dosisText) ?? 1,
                "fechaProgramada": fechaStr,
                "observaciones": txtObservaciones.text ?? ""
            ]

            // 5. Llamar al Servicio con Alertas
            VacunaService.shared.programarVacuna(idMascota: idMascota, datos: parametros, token: token) { [weak self] result in
                switch result {
                case .success:
                    self?.alertExito()
                case .failure(let error):
                    // Aquí usamos nuestra nueva alerta de error
                    self?.alertError(mensaje: error.localizedDescription)
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
    
    func alertError(mensaje: String) {
        let alert = UIAlertController(
            title: "Error",
            message: mensaje,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(alert, animated: true)
    }
}
