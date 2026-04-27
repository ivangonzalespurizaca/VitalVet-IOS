//
//  AplicarVacunaViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 20/04/26.
//

import UIKit
import Alamofire

class ListadoVacunasProgramadasViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var vistaamostrar: UIView!
    
    @IBOutlet weak var txtdni: UITextField!
    @IBOutlet weak var tvmascotas: UITableView!
    
    
    var listaMascotas: [Mascota] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vistaamostrar.isHidden = true
        tvmascotas.dataSource = self
        tvmascotas.delegate = self
        tvmascotas.rowHeight = 120
        tvmascotas.delaysContentTouches = false
    }
    
    @IBAction func btnBuscarDni(_ sender: UIButton) {
        guard let dni = txtdni.text, !dni.isEmpty else {
            print("Debes ingresar un DNI")
            return
        }
        buscarMascotasAlamofire(dni: dni)
    }
    
    func buscarMascotasAlamofire(dni: String) {
        guard let token = UserDefaults.standard.string(forKey: "userToken")else { return }
        let url = "https://apiveterinaria-production-238b.up.railway.app/api/mascotas/admin/buscar-por-dni"
        
        let parameters: [String: String] = ["dni": dni]
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "Accept": "application/json"]
        
        
        
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: headers)
        .validate() // Valida que el status code sea 200...299
        .responseDecodable(of: [Mascota].self) { response in
            
            switch response.result {
            case .success(let mascotas):
                self.listaMascotas = mascotas
                self.tvmascotas.reloadData()
                
                // Mostrar u ocultar vista según resultados
                self.vistaamostrar.isHidden = mascotas.isEmpty
                
                if mascotas.isEmpty {
                    print("No se encontraron mascotas.")
                }
                
            case .failure(let error):
                print("Error con Alamofire: \(error.localizedDescription)")
                // Opcional: podrías ocultar la vista si hay error
                self.vistaamostrar.isHidden = true
            }
        }
    }
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaMascotas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaxdni", for: indexPath) as! celdaMascotaxdni
        
        let mascota = listaMascotas[indexPath.row]
        cell.txtnombre.text = mascota.nombreMascota
        cell.txtraza.text = mascota.raza
        cell.txtEspecie.text = mascota.especie

        // Configurar Doble Tap
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(doubleTap)
        
        return cell
    }

    @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: tvmascotas)
        if let indexPath = tvmascotas.indexPathForRow(at: touchPoint) {
            performSegue(withIdentifier: "cambiarestado", sender: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "programacion", sender: nil)
        
        
        let mascotaSeleccionada = listaMascotas[indexPath.row]
        print("Mascota seleccionada ID: \(mascotaSeleccionada.idMascota)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Caso 1: Programar Cita (Tap simple)
        if segue.identifier == "programacion" {
            if let indexPath = tvmascotas.indexPathForSelectedRow {
                let pantalla2 = segue.destination as! ProgramarcitaController
                pantalla2.id = listaMascotas[indexPath.row].idMascota
            }
        }
        // Caso 2: El nuevo Segue (Doble Tap)
        else if segue.identifier == "cambiarestado" {
            if let indexPath = sender as? IndexPath {
                let detalleVC = segue.destination as! CambiarEstadoController // Reemplaza con tu clase
                detalleVC.idMascota = listaMascotas[indexPath.row].idMascota
            }
        }
    }
    
    
}
    
    
    

    



