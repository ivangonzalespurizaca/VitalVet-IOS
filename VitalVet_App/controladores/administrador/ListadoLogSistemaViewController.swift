//
//  ConfirmarPagoCitaViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 20/04/26.
//

import UIKit

class ListadoLogSistemaViewController: UIViewControllerProfile, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "celdaLog", for: indexPath) as? celdaLog else {
                    return UITableViewCell()
                }
                cell.configurar(con: listaLogs[indexPath.row])
                return cell
    }
    
    
    @IBOutlet weak var txtFechaInicio: UITextField!
    @IBOutlet weak var txtFechaFin: UITextField!
    @IBOutlet weak var tvLogs: UITableView!
    
    var listaLogs: [LogDTO] = []
    let pickerInicio = UIDatePicker()
        let pickerFin = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvLogs.dataSource = self
        tvLogs.delegate = self
        
        // Ajuste para que la celda crezca según el contenido
        tvLogs.rowHeight = 170
        
        // Asignamos delegados para bloquear el teclado
        txtFechaInicio.delegate = self
        txtFechaFin.delegate = self
        
        configurarCalendarios()
        // Carga inicial segura
        cargarDatos(inicio: "", fin: "")
        
        txtFechaInicio.configurarEstiloVitalVet(icono: "calendar", placeholder: "Fecha Inicio")
        txtFechaFin.configurarEstiloVitalVet(icono: "calendar", placeholder: "Fecha Fin")
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            return false // No permite escribir nada
        }
    
    @IBAction func btnFiltrar(_ sender: UIButton) {
        // Validamos si están vacíos
            guard let ini = txtFechaInicio.text, !ini.isEmpty,
                  let fin = txtFechaFin.text, !fin.isEmpty else {
                
                // Si falta alguno, lanzamos una alerta
                let alerta = UIAlertController(title: "Atención", message: "Por favor, selecciona un rango de fechas para buscar.", preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alerta, animated: true)
                return
            }
            
            cargarDatos(inicio: ini, fin: fin)
    }
    
    
    func configurarCalendarios() {
            pickerInicio.datePickerMode = .date
            pickerFin.datePickerMode = .date
            
            if #available(iOS 13.4, *) {
                pickerInicio.preferredDatePickerStyle = .wheels
                pickerFin.preferredDatePickerStyle = .wheels
            }

            // VALIDACIÓN 2: Escuchar cambios para limitar fechas
            pickerInicio.addTarget(self, action: #selector(fechaInicioCambio), for: .valueChanged)
            pickerFin.addTarget(self, action: #selector(fechaFinCambio), for: .valueChanged)

            txtFechaInicio.inputView = pickerInicio
            txtFechaFin.inputView = pickerFin
            
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            // ESTO ES LO NUEVO:
            toolbar.barStyle = .default
            toolbar.isTranslucent = true // Le da ese efecto de vidrio esmerilado
            toolbar.backgroundColor = .systemBackground // Se adapta a modo claro/oscuro
            
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let btnDone = UIBarButtonItem(title: "Hecho", style: .prominent, target: self, action: #selector(cerrarPicker))
            
            // Cambia el color del texto a azul para que resalte sobre el gris/blanco
        btnDone.tintColor = .lightGray
            
            toolbar.setItems([flexSpace, btnDone], animated: true)
            
            txtFechaInicio.inputAccessoryView = toolbar
            txtFechaFin.inputAccessoryView = toolbar
        }
    
    @objc func fechaInicioCambio() {
        // La fecha fin no puede ser menor a la de inicio
        pickerFin.minimumDate = pickerInicio.date
        // Pero sigue sin poder pasarse de "hoy"
        pickerFin.maximumDate = Date()
    }

    @objc func fechaFinCambio() {
        // La fecha inicio no puede ser mayor a la de fin
        pickerInicio.maximumDate = pickerFin.date
    }
        
    @objc func cerrarPicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if txtFechaInicio.isFirstResponder {
            txtFechaInicio.text = formatter.string(from: pickerInicio.date)
        } else if txtFechaFin.isFirstResponder {
            txtFechaFin.text = formatter.string(from: pickerFin.date)
        }
        view.endEditing(true)
    }
    
    func cargarDatos(inicio: String, fin: String) {
            let token = UserDefaults.standard.string(forKey: "userToken") ?? ""
            LogService.shared.listarLogs(inicio: inicio, fin: fin, token: token) { resultado in
                DispatchQueue.main.async {
                    switch resultado {
                    case .success(let logs):
                        self.listaLogs = logs
                        self.tvLogs.reloadData()
                        
                        // Si la lista está vacía, avisamos al usuario
                        if logs.isEmpty {
                            let alerta = UIAlertController(title: "Sin resultados", message: "No se encontraron logs en el rango de fechas seleccionado.", preferredStyle: .alert)
                            alerta.addAction(UIAlertAction(title: "Continuar", style: .default))
                            self.present(alerta, animated: true)
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    }
            }
        }
    }

}
