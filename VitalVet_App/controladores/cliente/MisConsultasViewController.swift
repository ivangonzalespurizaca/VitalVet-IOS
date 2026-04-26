//
//  MisConsultasViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 20/04/26.
//

import UIKit
import Alamofire

class MisConsultasViewController: UIViewControllerProfile, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consultas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvConsulta.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! celdaConsulta
                let consulta = consultas[indexPath.row]
                
                cell.lblDiagnostico.text = consulta.diagnostico
                cell.lblFecha.text = "\(consulta.fechaConsulta) - \(consulta.nombreMascota)"
                
                cell.btnOpciones.tag = indexPath.row
                cell.btnOpciones.addTarget(self, action: #selector(clickOpciones(_:)), for: .touchUpInside)
                
                return cell
    }
    
    
    var consultas: [ConsultaDTO] = []
        var listaMascotas: [Mascota] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        cambiarTitulo(nuevoTexto: "Mis Consultas")
        tvConsulta.dataSource = self
        tvConsulta.delegate = self
        tvConsulta.rowHeight=120
                
        cargarMascotasYConsultas()
     
    }
    
    @IBOutlet weak var tvConsulta: UITableView!
    
    // 🔥 1. TRAER MASCOTAS
    func cargarMascotasYConsultas() {
           let defaults = UserDefaults.standard
           guard let token = defaults.string(forKey: "userToken"),
                 let userId = defaults.string(forKey: "userId") else {
               print("No hay sesión")
               return
           }

           let url = "https://apiveterinaria-production-238b.up.railway.app/api/mascotas/cliente/\(userId)"
           
           let headers: HTTPHeaders = [
               "Authorization": "Bearer \(token)",
               "Accept": "application/json"
           ]
           
        AF.request(url, headers: headers)
                   .responseDecodable(of: [Mascota].self) { response in
                       switch response.result {
                       case .success(let mascotas):
                           print("Mascotas obtenidas: \(mascotas.count)")
                           self.listaMascotas = mascotas
                           self.cargarConsultasDeMascotas(token: token)
                       case .failure(let error):
                           print("Error al obtener las mascotas: \(error.localizedDescription)")
                           self.mostrarError(message: "No se pudieron cargar las mascotas. Intente nuevamente.")
                       }
                   }
       }
        // 🔥 2. TRAER CONSULTAS
    func cargarConsultasDeMascotas(token: String) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        let group = DispatchGroup()
        var todas: [ConsultaDTO] = []
        
        for mascota in listaMascotas {
            group.enter()
            
            let url = "https://apiveterinaria-production-238b.up.railway.app/api/consultas/mascota/\(mascota.idMascota)"
            
            AF.request(url, headers: headers)
                        .responseData { response in
                            if response.error != nil {
                                // Si hay un error de conexión, mostramos el mensaje de error
                                print("❌ Error al obtener datos para la mascota \(mascota.idMascota): \(response.error?.localizedDescription ?? "Desconocido")")
                                self.mostrarError(message: "Hubo un error al cargar las consultas. Intente nuevamente.")
                            } else if let data = response.data {
                                // Si la respuesta es válida y no hay error de conexión
                                do {
                                    let consultas = try JSONDecoder().decode([ConsultaDTO].self, from: data)
                                    
                                    if consultas.isEmpty {
                                        // Si no hay consultas para esta mascota, no mostramos error
                                        print("❌ No hay consultas para la mascota \(mascota.idMascota)")
                                    } else {
                                        // Si hay consultas, las agregamos a la lista
                                        print("✅ Consultas decodificadas para la mascota \(mascota.idMascota): \(consultas.count)")
                                        todas.append(contentsOf: consultas)
                                    }
                                } catch {
                                    // Si ocurre un error de decodificación, mostramos un error
                                    print("❌ ERROR DECODIFICANDO para mascota \(mascota.idMascota): \(error)")
                                    self.mostrarError(message: "No se pudieron cargar las consultas para la mascota. Intente nuevamente.")
                                }
                            }
                            
                            group.leave()
                        }
        }
        
        group.notify(queue: .main) {
            self.consultas = todas.sorted { $0.fechaConsulta > $1.fechaConsulta }
            print("🔥 Total de consultas cargadas: \(self.consultas.count)")
            self.tvConsulta.reloadData()
        }
    }
    
    // MARK: - Botón Opciones
        @objc func clickOpciones(_ sender: UIButton) {
            let consulta = consultas[sender.tag]
            let alert = UIAlertController(title: "Opciones", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Ver detalle", style: .default, handler: { _ in
                self.mostrarDetalleConsulta(consulta)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
            
            present(alert, animated: true)
        }

        func mostrarDetalleConsulta(_ consulta: ConsultaDTO) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetalleConsultaViewController") as! DetalleConsultaViewController
            vc.consulta = consulta
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
    // MARK: - Mostrar error
       func mostrarError(message: String) {
           let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
           present(alert, animated: true)
       }
    
}
