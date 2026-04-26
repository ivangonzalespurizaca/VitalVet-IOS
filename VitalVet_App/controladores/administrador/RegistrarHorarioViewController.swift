//
//  RegistroHorarioServiceViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 25/04/26.
//

import UIKit

class RegistrarHorarioViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listaDiasSemana.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listaDiasSemana[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtDiaSemana.text = listaDiasSemana[row]
    }
    
    private func configurarDatePicker(_ picker: UIDatePicker, para textField: UITextField) {
        picker.datePickerMode = .time
        picker.minuteInterval = 30
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "en_GB") // Formato 24h
        textField.inputView = picker
    }
    
    
    
    
    @IBOutlet weak var txtDiaSemana: UITextField!
    @IBOutlet weak var txtHoraInicio: UITextField!
    @IBOutlet weak var txtHoraFin: UITextField!
    @IBOutlet weak var pvDiaSemana: UIPickerView!
    
    let dpHoraInicio = UIDatePicker()
    let dpHoraFin = UIDatePicker()
    
    
    var idVeterinarioRecibido: Int?
    var listaDiasSemana: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        cargarDiasSemana()
        pvDiaSemana.delegate = self
        pvDiaSemana.dataSource = self
        
        configurarDatePicker(dpHoraInicio, para: txtHoraInicio)
        configurarDatePicker(dpHoraFin, para: txtHoraFin)
        
        configurarToolbar(para: txtDiaSemana)
        configurarToolbar(para: txtHoraInicio)
        configurarToolbar(para: txtHoraFin)
    }
    
    @IBAction func btnRegistrarHorario(_ sender: Any) {
        guard let idVet = idVeterinarioRecibido,
              let dia = txtDiaSemana.text, !dia.isEmpty,
              let token = UserDefaults.standard.string(forKey: "userToken") else {
            self.mostrarAlerta(mensaje: "Por favor, completa todos los campos.")
            return
        }

        if dpHoraFin.date <= dpHoraInicio.date {
            self.mostrarAlerta(mensaje: "La hora de fin debe ser posterior a la hora de inicio.")
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let horaInicioLimpia = "\(formatter.string(from: dpHoraInicio.date)):00"
        let horaFinLimpia = "\(formatter.string(from: dpHoraFin.date)):00"

        // 4. Crear el objeto DTO para el registro
        let nuevoHorario = HorarioRegister(
            idVeterinario: idVet,
            diaSemana: dia,
            horaInicio: horaInicioLimpia,
            horaFin: horaFinLimpia
        )

        // 5. Llamar al servicio
        HorarioService.shared.registrarHorario(datos: nuevoHorario, token: token) { [weak self] resultado in
            DispatchQueue.main.async {
                switch resultado {
                case .success:
                    self?.mostrarAlertaExito()
                case .failure(let error):
                    print("DEBUG: Error al registrar -> \(error)")
                    self?.mostrarAlerta(mensaje: "Hubo un error al registrar el horario.")
                }
            }
        }
    }
    
    private func cargarDiasSemana() {
        EnumService().obtenerDiasSemana { [weak self] lista in
            if let lista = lista {
                self?.listaDiasSemana = lista
                DispatchQueue.main.async { self?.pvDiaSemana.reloadAllComponents() }
            }
        }
    }
    
    private func configurarToolbar(para textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let btnDone = UIBarButtonItem(title: "Hecho", style: .prominent, target: self, action: #selector(cerrarPicker))
        let espacio = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([espacio, btnDone], animated: false)
        textField.inputAccessoryView = toolbar
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
    
    private func mostrarAlerta(mensaje: String) {
        let alerta = UIAlertController(title: "Atención", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }

    private func mostrarAlertaExito() {
        let alerta = UIAlertController(title: "¡Éxito!", message: "Horario asignado correctamente", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Genial", style: .default) { _ in
            // Regresamos a la pantalla anterior para ver la tabla actualizada
            self.navigationController?.popViewController(animated: true)
        })
        present(alerta, animated: true)
    }
    

}
