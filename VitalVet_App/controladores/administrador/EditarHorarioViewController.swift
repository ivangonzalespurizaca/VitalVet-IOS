//
//  EditarHorarioViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 25/04/26.
//

import UIKit

class EditarHorarioViewController: UIViewController {
    
    @IBOutlet weak var txtDiaSemana: UITextField!
    @IBOutlet weak var txtHoraInicio: UITextField!
    @IBOutlet weak var txtHoraFin: UITextField!
    @IBOutlet weak var swActivo: UISwitch!
    
    var horarioRecibido: HorarioInfo?
    let dpHoraInicio = UIDatePicker()
    let dpHoraFin = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarUI()
        cargarDatos()
    }
    
    @IBAction func btnEditarHorario(_ sender: Any) {
        // 1. Validaciones básicas y obtención de datos necesarios
            guard let idHorario = horarioRecibido?.idHorario,
                  let token = UserDefaults.standard.string(forKey: "userToken") else {
                print("Error: No se encontró el ID del horario o el token")
                return
            }

            // 2. Validación de lógica de tiempo (Fin posterior a Inicio)
            if dpHoraFin.date <= dpHoraInicio.date {
                let alerta = UIAlertController(title: "Horario Inválido",
                                              message: "La hora de fin debe ser posterior a la de inicio.",
                                              preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "Entendido", style: .default))
                present(alerta, animated: true)
                return
            }
        
            // 3. Formatear para el Backend (HH:mm:ss)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
        
        let horaInicioLimpia = "\(formatter.string(from: dpHoraInicio.date)):00"
        let horaFinLimpia = "\(formatter.string(from: dpHoraFin.date)):00"

            // Creamos el objeto usando tu struct HorarioUpdate
            let horarioActualizado = HorarioUpdate(
                horaInicio: horaInicioLimpia,
                horaFin: horaFinLimpia,
                activo: swActivo.isOn
            )

            // 4. Llamada al servicio (Método PUT)
            HorarioService.shared.actualizarHorario(idHorario: idHorario, datos: horarioActualizado, token: token) { [weak self] resultado in
                DispatchQueue.main.async {
                    switch resultado {
                    case .success:
                        self?.mostrarAlertaExito()
                    case .failure(let error):
                        print("Error al actualizar: \(error.localizedDescription)")
                        // Podrías mostrar una alerta de error aquí
                    }
                }
            }
    }
    
    
    private func configurarUI() {
        txtDiaSemana.isEnabled = false // El día no se suele editar
        configurarDatePicker(dpHoraInicio, para: txtHoraInicio)
        configurarDatePicker(dpHoraFin, para: txtHoraFin)
        configurarToolbar(para: txtHoraInicio)
        configurarToolbar(para: txtHoraFin)
    }
    
    private func cargarDatos() {
        guard let h = horarioRecibido else { return }
        txtDiaSemana.text = h.diaSemana
        txtHoraInicio.text = String(h.horaInicio.prefix(5))
        txtHoraFin.text = String(h.horaFin.prefix(5))
        swActivo.isOn = h.activo
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        if let dateInicio = formatter.date(from: h.horaInicio) { dpHoraInicio.date = dateInicio }
        if let dateFin = formatter.date(from: h.horaFin) { dpHoraFin.date = dateFin }
    }
    
    private func configurarDatePicker(_ picker: UIDatePicker, para textField: UITextField) {
        picker.datePickerMode = .time
        picker.minuteInterval = 30
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "en_GB") // Formato 24h
        textField.inputView = picker
    }
    
    
    private func configurarToolbar(para textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let btnDone = UIBarButtonItem(title: "Hecho", style: .prominent, target: self, action: #selector(cerrarPicker))
        let espacio = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([espacio, btnDone], animated: false)
        textField.inputAccessoryView = toolbar
    }
    
    private func mostrarAlertaExito() {
        let alerta = UIAlertController(title: "¡Actualizado!",
                                      message: "El horario se ha modificado correctamente.",
                                      preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            // Regresa a la lista. Gracias al viewWillAppear de la pantalla anterior, se refrescará sola.
            self.navigationController?.popViewController(animated: true)
        })
        present(alerta, animated: true)
    }
    
    @objc func cerrarPicker() {
        let formatter = DateFormatter()
        
        if txtDiaSemana.isFirstResponder {
            // No hace falta formatear, el delegate del picker ya lo hace
        } else if txtHoraInicio.isFirstResponder {
            formatter.dateFormat = "HH:mm"
            txtHoraInicio.text = formatter.string(from: dpHoraInicio.date)
        } else if txtHoraFin.isFirstResponder {
            formatter.dateFormat = "HH:mm"
            txtHoraFin.text = formatter.string(from: dpHoraFin.date)
        }
        
        view.endEditing(true) // Oculta el picker
    }
    
    
    

}
