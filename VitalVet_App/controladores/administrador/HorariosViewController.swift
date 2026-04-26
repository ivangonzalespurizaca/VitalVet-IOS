//
//  GestionarHorariosViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 20/04/26.
//

import UIKit

class HorariosViewController: UIViewControllerProfile, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaHorarios.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvHorarios.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CeldaHorarios
        let horario = listaHorarios[indexPath.row]
        
        cell.lblDiaHora.text = "\(horario.diaSemana): \(horario.horaInicio) - \(horario.horaFin)"
        cell.lblEstado.text = horario.activo ? "Estado: Activo" : "Estado: Inactivo"
        cell.lblEstado.textColor = horario.activo ? .systemGreen : .systemRed
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueDatosHorario", sender: nil)
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listaVets.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let vet = listaVets[row]
        return "\(vet.nombres) \(vet.apellidos)"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let vet = listaVets[row]
        vetSeleccionado = vet
        txtVeterinario.text = "\(vet.nombres) \(vet.apellidos)"
    }
    
    var listaVets: [VeterinarioInfo] = []
    var listaHorarios: [HorarioInfo] = []
    var vetSeleccionado: VeterinarioInfo?
    
    @IBOutlet weak var txtVeterinario: UITextField!
    @IBOutlet weak var pvVeterinario: UIPickerView!
    @IBOutlet weak var tvHorarios: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        cambiarTitulo(nuevoTexto: "Gestionar Horarios")
        
        tvHorarios.delegate = self
        tvHorarios.dataSource = self
        pvVeterinario.delegate = self
        pvVeterinario.dataSource = self
        tvHorarios.rowHeight = 60
        cargarVeterinarios()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if vetSeleccionado != nil {
            btnBuscarHorario(self)
        }
    }

    private func cargarVeterinarios() {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        
        VeterinarioService.shared.listarVeterinarios(token: token) { [weak self] resultado in
            if case .success(let vets) = resultado {
                self?.listaVets = vets
                DispatchQueue.main.async {
                    self?.pvVeterinario.reloadAllComponents()
                    if !vets.isEmpty {
                        self?.vetSeleccionado = vets[0]
                        self?.txtVeterinario.text = "\(vets[0].nombres) \(vets[0].apellidos)"
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    @IBAction func btnBuscarHorario(_ sender: Any) {
        guard let idVet = vetSeleccionado?.idVeterinario,
              let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("Selecciona un veterinario primero")
            return
        }
        
        HorarioService.shared.listarHorariosPorVeterinario(idVet: idVet, token: token) { [weak self] resultado in
            switch resultado {
            case .success(let horarios):
                self?.listaHorarios = horarios
                DispatchQueue.main.async {
                    self?.tvHorarios.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func btnAgregar(_ sender: Any) {
        if vetSeleccionado != nil {
            performSegue(withIdentifier: "segueNuevoHorario", sender: nil)
        } else {
            print("Error: Seleccione un veterinario")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Segue para REGISTRAR (Nuevo)
        if segue.identifier == "segueNuevoHorario",
           let pantallaDestino = segue.destination as? RegistrarHorarioViewController {
            pantallaDestino.idVeterinarioRecibido = vetSeleccionado?.idVeterinario
        }
        
        // Segue para DETALLES / EDITAR (Existente)
        if segue.identifier == "segueDatosHorario",
           let pantallaDestino = segue.destination as? EditarHorarioViewController, // Asegúrate que el nombre de la clase sea este
           let indice = tvHorarios.indexPathForSelectedRow?.row {
            
            let horarioSeleccionado = listaHorarios[indice]
            pantallaDestino.horarioRecibido = horarioSeleccionado
        }
    }
    
}
