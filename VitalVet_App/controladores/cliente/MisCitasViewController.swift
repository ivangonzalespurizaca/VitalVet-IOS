//
//  MisCitasViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 20/04/26.
//

import UIKit
import Kingfisher

class MisCitasViewController: UIViewControllerProfile, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citasFiltradas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CeldaCitas
        let cita = citasFiltradas[indexPath.row]
        
        cell.lblMascota.text = "Mascota: \(cita.nombreMascota)"
        cell.lblVeterinario.text = "Vet: \(cita.nombreVeterinario)"
        cell.lblFechaHora.text = "Fecha: \(cita.fecha) - \(cita.hora.prefix(5))"
        cell.lblEstado.text = cita.estado
        
        // Colores según estado
        switch cita.estado {
        case "PENDIENTE": cell.lblEstado.textColor = .systemOrange
        case "CONFIRMADA": cell.lblEstado.textColor = .systemBlue
        case "COMPLETADA": cell.lblEstado.textColor = .systemGreen
        case "CANCELADA": cell.lblEstado.textColor = .systemRed
        default: cell.lblEstado.textColor = .black
        }
        
        // Cargar imagen (Si usas Kingfisher)
        if let url = URL(string: cita.fotoMascotaUrl ?? "") {
            cell.imgMascota.kf.setImage(with: url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let citaSeleccionada = citasFiltradas[indexPath.row]
        performSegue(withIdentifier: "segueDatosCita", sender: citaSeleccionada)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Validamos que sea el segue correcto
        if segue.identifier == "segueDatosCita" {
            // Validamos que el destino sea DatosCitaViewController y que el sender sea una CitaInfo
            if let destinoVC = segue.destination as? DatosCitaViewController,
               let citaParaEnviar = sender as? CitaInfo {
                
                // Le pasamos la cita al controlador de detalle
                destinoVC.cita = citaParaEnviar
            }
        }
    }
    
    var listaCitas: [CitaInfo] = []
    var citasFiltradas: [CitaInfo] = []
    
    @IBOutlet weak var scFiltroEstado: UISegmentedControl!
    @IBOutlet weak var tvCitas: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        cambiarTitulo(nuevoTexto: "Mis Citas")
        tvCitas.delegate = self
        tvCitas.dataSource = self
        tvCitas.rowHeight = 140
        configurarSegmentedControl()
        cargarCitas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cargarCitas()
    }
    
    
    
    @IBAction func btnAgregarCita(_ sender: Any) {
        performSegue(withIdentifier: "segueSeleccionarVet", sender: nil)
    }
    
    @IBAction func cambioFiltro(_ sender: Any) {
        filtrarCitasPorEstado()
    }
    
    
    func cargarCitas() {
        guard let idCliente = UserDefaults.standard.string(forKey: "userId"),
              let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        
        CitaService.shared.buscarCitasPorCliente(idCliente: idCliente, token: token) { [weak self] resultado in
            switch resultado {
            case .success(let citas):
                self?.listaCitas = citas
                self?.filtrarCitasPorEstado() // Filtramos según el SegmentedControl inicial
            case .failure(let error):
                print("Error cargando citas: \(error)")
            }
        }
    }
    
    private func configurarSegmentedControl() {
        scFiltroEstado.removeAllSegments()
        scFiltroEstado.insertSegment(withTitle: "Todos", at: 0, animated: false)
        scFiltroEstado.insertSegment(withTitle: "Pendientes", at: 1, animated: false)
        scFiltroEstado.insertSegment(withTitle: "Confirmados", at: 2, animated: false)
        scFiltroEstado.insertSegment(withTitle: "Completados", at: 3, animated: false)
        scFiltroEstado.selectedSegmentIndex = 0
    }
    
    private func filtrarCitasPorEstado() {
        let indice = scFiltroEstado.selectedSegmentIndex
        
        switch indice {
        case 1: // Pendientes
            citasFiltradas = listaCitas.filter { $0.estado == "PENDIENTE" }
        case 2: // Confirmados
            citasFiltradas = listaCitas.filter { $0.estado == "CONFIRMADA" }
        case 3: // Completados
            citasFiltradas = listaCitas.filter { $0.estado == "COMPLETADA" }
        default: // Todos
            citasFiltradas = listaCitas
        }
        
        DispatchQueue.main.async {
            self.tvCitas.reloadData()
        }
    }
}
