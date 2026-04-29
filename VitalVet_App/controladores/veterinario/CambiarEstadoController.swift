//
//  CambiarEstadoController.swift
//  VitalVet_App
//
//  Created by XCODE on 27/04/26.
//

import UIKit
import Alamofire

class CambiarEstadoController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tvCarnet: UITableView!
        
    var idMascota: Int? // Este valor viene del segue anterior
    var listaVacunas: [VacunaAplicada] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tvCarnet.dataSource = self
        tvCarnet.delegate = self
        tvCarnet.rowHeight = 120
        
        if let id = idMascota {
            cargarCarnet(id: id)
        }
    }

    func cargarCarnet(id: Int) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        let url = "https://apiveterinaria-production-238b.up.railway.app/api/vacunas-aplicadas/mascota/\(id)/carnet"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "Accept": "application/json"]

        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [VacunaAplicada].self) { response in
                
                switch response.result {
                case .success(let vacunas):
                    self.listaVacunas = vacunas
                    self.tvCarnet.reloadData()
                case .failure(let error):
                    print("Error detallado: \(error)")
                    
                    if case .responseSerializationFailed(let reason) = error {
                        print("Razón de la falla: \(reason)")
                    }
                }
            }
    }
        
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaVacunas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaCarnet", for: indexPath) as! CarnetTableViewCell
        
        let vacuna = listaVacunas[indexPath.row]
        cell.txtnombre.text = vacuna.nombreVacuna
        cell.txtEstado.text = vacuna.estado
        
        // Lógica para la fecha:
        if let aplicada = vacuna.fechaAplicacion, !aplicada.isEmpty {
            cell.txtFecha.text = aplicada
        } else {
            cell.txtFecha.text = "Fecha a aplicar \(vacuna.fechaProgramada ?? "")"
        }
        
        cell.txtEstado.textColor = (vacuna.estado == "APLICADA") ? .systemGreen : .systemOrange
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vacuna = listaVacunas[indexPath.row]
        
        if vacuna.estado == "PROGRAMADA" {
            mostrarAlertaConfirmacion(vacuna: vacuna)
        }
    }
    
    func mostrarAlertaConfirmacion(vacuna: VacunaAplicada) {
        let alerta = UIAlertController(title: "Confirmar Aplicación",
                                       message: "¿Deseas marcar la vacuna \(vacuna.nombreVacuna ?? "") como aplicada?",
                                       preferredStyle: .alert)
        
        alerta.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { _ in
            self.confirmarVacunaAPI(vacuna: vacuna)
        }))
        
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        present(alerta, animated: true)
    }

    func confirmarVacunaAPI(vacuna: VacunaAplicada) {
        guard let token = UserDefaults.standard.string(forKey: "userToken"),
              let idMascota = self.idMascota,
              let idApp = vacuna.idAplicacion else { return }
        
        let fechaFormateada = Date().toString()
        
        let url = "https://apiveterinaria-production-238b.up.railway.app/api/vacunas-aplicadas/consulta/\(idMascota)/confirmar"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "idAplicacion": idApp,
            "fechaAplicacion": fechaFormateada,
            "observaciones": "Vacuna aplicada exitosamente vía VitalVet App"
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                
                switch response.result {
                case .success:
                    print("Vacuna confirmada con éxito")
                    self.cargarCarnet(id: idMascota)
                    
                    let alerta = UIAlertController(title: "Logrado", message: "Estado actualizado", preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alerta, animated: true)

                case .failure(let error):
                    print("Error al confirmar: \(error.localizedDescription)")
                }
            }
    }
}

extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
}
