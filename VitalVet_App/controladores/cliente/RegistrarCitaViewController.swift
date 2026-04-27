//
//  RegistrarCitaViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 26/04/26.
//

import UIKit

class RegistrarCitaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listaSlots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celdaSlot", for: indexPath) as! CeldaCollectionSlotHorario
        let slot = listaSlots[indexPath.item]
        cell.lblHora.text = slot.hora.prefix(5).description
        
        let seleccionado = (slot.hora == horaSeleccionada)
        cell.configurarSeleccion(estaSeleccionado: seleccionado, esDisponible: slot.disponible)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        horaSeleccionada = listaSlots[indexPath.item].hora
        collectionView.reloadData()
        print("Seleccionaste: \(horaSeleccionada ?? "")")
    }
    
    @IBOutlet weak var dpFecha: UIDatePicker!
    @IBOutlet weak var lblResumen: UILabel!
    @IBOutlet weak var cvSlotHorarios: UICollectionView!
    @IBOutlet weak var txtMotivo: UITextField!
    
    var idMascotaRecibido : Int?
    var idVetRecibido: Int?
    var nombreVetRecibido: String?
    
    var horaSeleccionada: String?
    
    var listaSlots: [SlotHorario] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvSlotHorarios.dataSource = self
        cvSlotHorarios.delegate = self
        lblResumen.text = "Cita con: \(nombreVetRecibido ?? "Vet")"
        dpFecha.minimumDate = Date()
        dpFecha.addTarget(self, action: #selector(fechaCambio), for: .valueChanged)
        fechaCambio()
    }
    
    @IBAction func btnRegistrar(_ sender: Any) {
        // 1. Validaciones previas
        guard let hora = horaSeleccionada else {
            mostrarAlerta(titulo: "Faltan datos", mensaje: "Por favor, selecciona un horario para la cita.")
            return
        }
        
        guard let motivo = txtMotivo.text, !motivo.isEmpty else {
            mostrarAlerta(titulo: "Faltan datos", mensaje: "Por favor, escribe el motivo de la consulta.")
            return
        }
        
        guard let idMascota = idMascotaRecibido,
              let idVet = idVetRecibido,
              let token = UserDefaults.standard.string(forKey: "userToken") else {
            mostrarAlerta(titulo: "Error", mensaje: "No se pudo recuperar la información de la mascota o el veterinario.")
            return
        }

        // 2. Formatear la fecha seleccionada
        let formato = DateFormatter()
        formato.dateFormat = "yyyy-MM-dd"
        let fechaStr = formato.string(from: dpFecha.date)

        // 3. Crear el objeto para el API
        let nuevaCita = CitaRegister(
            idMascota: idMascota,
            idVeterinario: idVet,
            fecha: fechaStr,
            hora: hora,
            motivo: motivo
        )

        // 4. Llamar al servicio
        CitaService.shared.registrarCita(datos: nuevaCita, token: token) { [weak self] resultado in
            DispatchQueue.main.async {
                switch resultado {
                case .success:
                    // Mensaje de éxito
                    let alertaExito = UIAlertController(title: "¡Cita Registrada!", message: "Tu cita ha sido programada con éxito.", preferredStyle: .alert)
                    let accionOk = UIAlertAction(title: "Genial", style: .default) { _ in
                        // Regresar a la pantalla de inicio (Root) o a la lista de citas
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                    alertaExito.addAction(accionOk)
                    self?.present(alertaExito, animated: true)
                    
                case .failure(let error):
                    self?.mostrarAlerta(titulo: "Error al registrar", mensaje: error.localizedDescription)
                }
            }
        }
    }
    
    @objc func fechaCambio() {
        let formato = DateFormatter()
        formato.dateFormat = "yyyy-MM-dd"
        let fechaSeleccionada = formato.string(from: dpFecha.date)
        print("¡La fecha cambió!")
        cargarDisponibilidad(fecha: fechaSeleccionada)
    }
    
    private func cargarDisponibilidad(fecha: String) {
        guard let idVet = idVetRecibido,
              let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        
        CitaService.shared.consultarDisponibilidad(idVet: idVet, fecha: fecha, token: token) { [weak self] resultado in
            switch resultado {
            case .success(let slots):
                print("DEBUG: Llegaron \(slots.count) slots del servidor")
                self?.listaSlots = slots
                DispatchQueue.main.async {
                    self?.cvSlotHorarios.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Entendido", style: .default))
        self.present(alerta, animated: true)
    }
    
    

}
