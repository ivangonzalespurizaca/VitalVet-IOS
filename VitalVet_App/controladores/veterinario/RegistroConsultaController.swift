import UIKit
import Alamofire

class RegistroConsultaController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerCitas: UIPickerView!
    @IBOutlet weak var viewFormulario: UIView!
    
    @IBOutlet weak var txtPeso: UITextField!
    @IBOutlet weak var txtTemperatura: UITextField!
    @IBOutlet weak var txtDiagnostico: UITextView!
    @IBOutlet weak var txtRecomendaciones: UITextView!
    @IBOutlet weak var lblContadorTratamientos: UILabel!
    @IBOutlet weak var lblContadorVacunas: UILabel!

  
    var listaCitas: [CitaConfirmada] = []
    var todasLasVacunas: [VacunaDisponible] = []
    
    var citaSeleccionada: CitaConfirmada?
    var tratamientosAgregados: [TratamientoRequest] = []
    var vacunasAgregadas: [VacunaRequest] = []
    
    let loader = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerCitas.delegate = self
        pickerCitas.dataSource = self

        viewFormulario.isHidden = true
        
        // Cargar ambos datos al iniciar
        cargarCitasDesdeAPI()
        cargarCatalogoVacunas()
    }

    // MARK: - Carga de Datos (GET)
    
    @IBAction func btnAgregarTratamiento(_ sender: UIButton) {
        let alert = UIAlertController(title: "Nuevo Tratamiento", message: "Todos los campos son obligatorios", preferredStyle: .alert)
        
        alert.addTextField { $0.placeholder = "Medicamento" }
        alert.addTextField { $0.placeholder = "Dosis (ej: 1 tableta)" }
        alert.addTextField { $0.placeholder = "Frecuencia (ej: Cada 8h)" }
        alert.addTextField { $0.placeholder = "Días (duración)"; $0.keyboardType = .numberPad }
        
        let actionAñadir = UIAlertAction(title: "Añadir", style: .default) { _ in
            // Extraemos y limpiamos espacios en blanco
            let nombre = alert.textFields?[0].text?.trimmingCharacters(in: .whitespaces) ?? ""
            let dosis = alert.textFields?[1].text?.trimmingCharacters(in: .whitespaces) ?? ""
            let frecuencia = alert.textFields?[2].text?.trimmingCharacters(in: .whitespaces) ?? ""
            let diasStr = alert.textFields?[3].text?.trimmingCharacters(in: .whitespaces) ?? ""
            
            if nombre.isEmpty || dosis.isEmpty || frecuencia.isEmpty || diasStr.isEmpty {
                self.mostrarErrorValidacion(mensaje: "Debe completar todos los campos del tratamiento.")
                return
            }
            guard let diasInt = Int(diasStr), diasInt > 0 else {
                self.mostrarErrorValidacion(mensaje: "La duración en días debe ser un número válido.")
                return
            }
            
            let t = TratamientoRequest(
                nombreMedicamento: nombre,
                dosis: dosis,
                frecuencia: frecuencia,
                duracionDias: diasInt
            )
            
            self.tratamientosAgregados.append(t)
            
            self.lblContadorTratamientos.text = "\(self.tratamientosAgregados.count) tratamientos listos"
            self.lblContadorTratamientos.textColor = .systemBlue
        }
        
        alert.addAction(actionAñadir)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        present(alert, animated: true)
    }

    func pedirDetallesVacuna(id: Int, nombre: String) {
        let alert = UIAlertController(title: nombre, message: "Detalles de aplicación", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Nro Dosis (Obligatorio)"; $0.keyboardType = .numberPad }
        alert.addTextField { $0.placeholder = "Observaciones" }
        
        alert.addAction(UIAlertAction(title: "Guardar", style: .default) { _ in
            let dosisStr = alert.textFields?[0].text ?? ""
            
            // VALIDACIÓN: Nro de dosis obligatorio
            if dosisStr.isEmpty || (Int(dosisStr) ?? 0) <= 0 {
                self.mostrarErrorValidacion(mensaje: "Debe ingresar un número de dosis válido.")
                return
            }
            
            let v = VacunaRequest(
                idVacuna: id,
                nroDosis: Int(dosisStr) ?? 1,
                observaciones: alert.textFields?[1].text ?? ""
            )
            
            self.vacunasAgregadas.append(v)
            self.lblContadorVacunas.text = "\(self.vacunasAgregadas.count) vacunas listas"
            self.lblContadorVacunas.textColor = .systemGreen
        })
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
    func mostrarErrorValidacion(mensaje: String) {
        let alerta = UIAlertController(title: "Faltan datos", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Entendido", style: .default))
        self.present(alerta, animated: true)
    }
    
    
    func cargarCatalogoVacunas() {
        guard let token = UserDefaults.standard.string(forKey: "userToken")else { return }
        
        let url = "https://apiveterinaria-production-238b.up.railway.app/api/vacunas"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "Accept": "application/json"]
        AF.request(url,headers: headers).responseDecodable(of: [VacunaDisponible].self) { response in
            if let vacunas = response.value {
                self.todasLasVacunas = vacunas
            }
        }
    }

    func cargarCitasDesdeAPI() {
        guard let token = UserDefaults.standard.string(forKey: "userToken"),
              let userId = UserDefaults.standard.string(forKey: "userId") else { return }
        
        let url = "https://apiveterinaria-production-238b.up.railway.app/api/citas/veterinario/\(userId)/estado/CONFIRMADA"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "Accept": "application/json"]

        AF.request(url, headers: headers).validate().responseDecodable(of: [CitaConfirmada].self) { response in
            if let citas = response.value {
                self.listaCitas = citas
                DispatchQueue.main.async { self.pickerCitas.reloadAllComponents() }
            }
        }
    }

    

    @IBAction func btnAgregarVacuna(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Seleccionar Vacuna", message: nil, preferredStyle: .actionSheet)
        
        for vacuna in todasLasVacunas {
            actionSheet.addAction(UIAlertAction(title: vacuna.nombreVacuna, style: .default) { _ in
                self.pedirDetallesVacuna(id: vacuna.idVacuna, nombre: vacuna.nombreVacuna)
            })
        }
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(actionSheet, animated: true)
    }

    

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return listaCitas.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(listaCitas[row].nombreMascota) (\(listaCitas[row].hora))"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.citaSeleccionada = listaCitas[row]
        
        // Limpiar listas y labels al cambiar de paciente
        self.tratamientosAgregados.removeAll()
        self.vacunasAgregadas.removeAll()
        self.lblContadorTratamientos.text = "Sin tratamientos"
        self.lblContadorVacunas.text = "Sin vacunas"
        
        UIView.animate(withDuration: 0.3) {
            self.viewFormulario.isHidden = false
        }
    }
    
    
    
    @IBAction func btnRegistrar(_ sender: UIButton) {
        guard let cita = citaSeleccionada else {
            mostrarErrorValidacion(mensaje: "Debe seleccionar una cita.")
            return
        }
        
        let peso = txtPeso.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let temperatura = txtTemperatura.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let diagnostico = txtDiagnostico.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let recomendaciones = txtRecomendaciones.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        if peso.isEmpty || temperatura.isEmpty || diagnostico.isEmpty {
            mostrarErrorValidacion(mensaje: "Peso, Temperatura y Diagnóstico son obligatorios.")
            return
        }
        
        guard let pesoDouble = Double(peso), let tempDouble = Double(temperatura) else {
            mostrarErrorValidacion(mensaje: "Ingresa valores numéricos válidos.")
            return
        }

        // ENVIAR ARREGLOS DIRECTAMENTE (si están vacíos, enviará [])
        let consultaFinal = ConsultaRequest(
            idCita: cita.idCita,
            pesoActual: pesoDouble,
            temperatura: tempDouble,
            diagnostico: diagnostico,
            recomendaciones: recomendaciones,
            tratamientos: self.tratamientosAgregados,
            vacunas: self.vacunasAgregadas
        )

        registrarConsultaEnServidor(datos: consultaFinal)
    }

    func registrarConsultaEnServidor(datos: ConsultaRequest) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        let url = "https://apiveterinaria-production-238b.up.railway.app/api/consultas/registrar"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "Accept": "application/json"]

        AF.request(url, method: .post, parameters: datos, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .response { response in
                // --- BLOQUE DE DEBUG ---
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("DEBUG SERVIDOR: \(utf8Text)") // Esto te dirá el error real en la consola
                }
                // ------------------------

                DispatchQueue.main.async {
                    switch response.result {
                    case .success:
                        self.notificarExitoYRegresar()
                    case .failure(let error):
                        // Intentamos sacar el mensaje real del servidor (como hicimos con las citas)
                        var mensajeError = "No se pudo registrar la consulta."
                        
                        if let data = response.data,
                           let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                            // Buscamos si hay errores específicos en el diccionario 'errors'
                            mensajeError = apiError.errors?.values.first ?? apiError.message ?? error.localizedDescription
                        }
                        
                        self.mostrarErrorValidacion(mensaje: mensajeError)
                    }
                }
            }
    }
    
    func notificarExitoYRegresar() {
        let alerta = UIAlertController(title: "¡Logrado!", message: "La consulta médica ha sido registrada con éxito.", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Aceptar", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alerta.addAction(actionOk)
        self.present(alerta, animated: true)
    }
    
    
}
