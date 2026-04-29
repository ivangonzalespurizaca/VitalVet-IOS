//
//  SeleccionarCitaViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 26/04/26.
//

import UIKit

class SeleccionarVeterinarioViewController: UIViewControllerProfile, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == pvMascota ? listaMascotas.count : listaVets.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pvMascota {
            return listaMascotas[row].nombreMascota
        } else {
            return "\(listaVets[row].nombres) \(listaVets[row].apellidos)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pvMascota {
                mascotaSeleccionada = listaMascotas[row]
                txtMascota.text = mascotaSeleccionada?.nombreMascota
            } else {
                vetSeleccionado = listaVets[row]
                txtVeterinario.text = "\(vetSeleccionado!.nombres) \(vetSeleccionado!.apellidos)"
                
                // Al seleccionar Vet, cargamos sus horarios base automáticamente
                if let idVet = vetSeleccionado?.idVeterinario {
                    cargarHorariosBase(idVet: idVet)
                }
            }
            validarBotonSiguiente()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return horariosBase.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CeldaHorariosDisponibles
        let horario = horariosBase[indexPath.row]
        
        let inicio = horario.horaInicio.prefix(5)
        let fin = horario.horaFin.prefix(5)
        
        // Diseño de la celda
        cell.lblFechaHora.text = "\(horario.diaSemana): \(inicio) - \(fin)"
        // Quitar el color gris al seleccionar
        cell.selectionStyle = .none
        
        return cell
    }
    
    @IBOutlet weak var txtMascota: UITextField!
    @IBOutlet weak var txtVeterinario: UITextField!
    @IBOutlet weak var tvHorariosDisponibles: UITableView!
    @IBOutlet weak var btnSiguiente: UIButton!
    
    var listaMascotas: [Mascota] = []
    var listaVets: [VeterinarioInfo] = []
    var horariosBase: [HorarioInfo] = []
	
    var mascotaSeleccionada: Mascota?
    var vetSeleccionado: VeterinarioInfo?
    
    let pvMascota = UIPickerView()
    let pvVeterinario = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarUI()
        cargarDatosIniciales()
        cambiarTitulo(nuevoTexto: "Registrar Cita: Paso 1")
    }
    
    private func configurarUI() {
        txtMascota.inputView = pvMascota
        txtVeterinario.inputView = pvVeterinario
        
        txtMascota.configurarEstiloVitalVet(icono: "pawprint.fill", placeholder: "Seleccionar Mascota")
        txtVeterinario.configurarEstiloVitalVet(icono: "person.badge.plus.fill", placeholder: "Seleccionar Veterinario")
        
        pvMascota.delegate = self
        pvVeterinario.delegate = self
        tvHorariosDisponibles.delegate = self
        tvHorariosDisponibles.dataSource = self
        tvHorariosDisponibles.rowHeight = 40
        
        // Opcional: Agregar un botón de "Hecho" arriba del picker para cerrarlo
        configurarToolbar(para: txtMascota)
        configurarToolbar(para: txtVeterinario)
        
        btnSiguiente.isEnabled = false // Se activa cuando elijas ambos
    }
    
    private func cargarDatosIniciales() {
        guard let idUsuario = UserDefaults.standard.string(forKey: "userId"),
              let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        
        // 1. Cargar Mascotas
        MascotaService.shared.listarMascotasPorCliente(idCliente: idUsuario, token: token) { [weak self] resultado in
            if case .success(let mascotas) = resultado {
                self?.listaMascotas = mascotas
                DispatchQueue.main.async {
                    self?.pvMascota.reloadAllComponents()
                }
            }
        }
        
        // 2. Cargar Veterinarios (el que ya tenías)
        CitaService.shared.listarVeterinariosDisponibles(token: token) { [weak self] resultado in
            if case .success(let vets) = resultado {
                self?.listaVets = vets
                DispatchQueue.main.async {
                    self?.pvVeterinario.reloadAllComponents()
                }
            }
        }
    }
    
    private func cargarHorariosBase(idVet: Int) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        
        // Usamos el nuevo servicio con el endpoint de "disponibles"
        HorarioService.shared.listarHorariosDisponibles(idVet: idVet, token: token) { [weak self] resultado in
            switch resultado {
            case .success(let horarios):
                // Ya vienen filtrados como activos desde el backend según tu Postman
                self?.horariosBase = horarios
                DispatchQueue.main.async {
                    self?.tvHorariosDisponibles.reloadData()
                }
            case .failure(let error):
                print("Error al cargar horarios: \(error.localizedDescription)")
            }
        }
    }

    private func validarBotonSiguiente() {
        let estaListo = (mascotaSeleccionada != nil && vetSeleccionado != nil)
        
        UIView.animate(withDuration: 0.3) {
            self.btnSiguiente.isEnabled = estaListo
            self.btnSiguiente.alpha = estaListo ? 1.0 : 0.5
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueRegistrarCita",
           let destino = segue.destination as? RegistrarCitaViewController {
            // Pasamos los objetos o IDs necesarios
            destino.idMascotaRecibido = mascotaSeleccionada?.idMascota
            destino.idVetRecibido = vetSeleccionado?.idVeterinario
            destino.nombreVetRecibido = "\(vetSeleccionado!.nombres) \(vetSeleccionado!.apellidos)"
        }
    }
    
    private func configurarToolbar(para textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let btnDone = UIBarButtonItem(title: "Hecho", style: .prominent, target: self, action: #selector(cerrarPicker))
        let espacio = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([espacio, btnDone], animated: false)
        textField.inputAccessoryView = toolbar
        btnDone.tintColor = UIColor.lightGray
    }

    @objc func cerrarPicker() {
        view.endEditing(true)
    }
    
    @IBAction func btnSiguiente(_ sender: Any) {
        performSegue(withIdentifier: "segueRegistrarCita", sender: nil)
    }
}
