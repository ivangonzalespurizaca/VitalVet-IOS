//
//  AprobarCitaViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 20/04/26.
//

import UIKit

class ListadoSolicitudCitasViewController: UIViewControllerProfile, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solicitudes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // "celda" debe ser el Identifier que pusiste en el Storyboard
                let cell = tableView.dequeueReusableCell(withIdentifier: "celdaCita", for: indexPath) as! celdaCita
                let cita = solicitudes[indexPath.row]
                
                cell.configurar(con: cita)
                
                // Configuramos la acción del botón de la celda
                cell.funcionAprobar = {
                    self.confirmarAprobacion(idCita: cita.idCita)
                }
                
                return cell
    }
    
    
    @IBOutlet weak var tvSolicitudes: UITableView!
    
    var solicitudes: [CitaInfo] = []
        
        // Obtenemos los datos de sesión (asegúrate de que estos nombres coincidan con tu login)
    let token = UserDefaults.standard.string(forKey: "userToken") ?? ""
    let idVetLogueado = UserDefaults.standard.string(forKey: "userId") ?? ""

    override func viewDidLoad() {
        super.viewDidLoad()
        cambiarTitulo(nuevoTexto: "Solicitud de Citas")
        
        // Configuración básica de la tabla
        tvSolicitudes.dataSource = self
        tvSolicitudes.delegate = self
        tvSolicitudes.rowHeight = 200
        tvSolicitudes.separatorStyle = .none
        // Cargar las citas desde el servidor
        cargarCitas()
     
    }
    
    func cargarCitas() {
            CitaService.shared.listarCitasPorVeterinario(idVet: idVetLogueado, token: token) { result in
                switch result {
                case .success(let lista):
                    // Ordenamos: PENDIENTES arriba, luego el resto
                    self.solicitudes = lista.sorted { $0.estado == "PENDIENTE" && $1.estado != "PENDIENTE" }
                    
                    DispatchQueue.main.async {
                        self.tvSolicitudes.reloadData()
                    }
                case .failure(let error):
                    print("Error al obtener citas: \(error.localizedDescription)")
                    // Aquí podrías mostrar una alerta si falla la conexión
                }
            }
        }
    
    func confirmarAprobacion(idCita: Int) {
        let alerta = UIAlertController(title: "Confirmar Cita", message: "¿Deseas aprobar esta solicitud de atención?", preferredStyle: .alert)
        
        alerta.addAction(UIAlertAction(title: "Sí, Aprobar", style: .default, handler: { _ in
            CitaService.shared.aprobarCita(idCita: idCita, token: self.token) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        // Mensaje de éxito al veterinario
                        let exito = UIAlertController(title: "¡Listo!", message: "La cita ha sido confirmada con éxito.", preferredStyle: .alert)
                        exito.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(exito, animated: true)
                        
                        self.cargarCitas() // Recarga la tabla
                    }
                case .failure(let error):
                    print("Error al aprobar: \(error)")
                }
            }
        }))
        
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alerta, animated: true)
    }

}
