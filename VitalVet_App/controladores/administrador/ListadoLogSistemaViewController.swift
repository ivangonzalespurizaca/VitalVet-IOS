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
        cambiarTitulo(nuevoTexto: "Log Sistema")
        
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
        
        // 1. Quitamos el estilo nativo para que nos deje personalizar
        txtFechaInicio.borderStyle = .none
        txtFechaFin.borderStyle = .none
        
        // 2. Aplicamos el diseño manualmente al "contenedor" del campo
        [txtFechaInicio, txtFechaFin].forEach { field in
            field?.layer.cornerRadius = 8
            field?.layer.borderWidth = 1.0
            field?.layer.borderColor = UIColor.systemGray4.cgColor
            field?.layer.masksToBounds = true
            field?.backgroundColor = .white // Asegura que no sea transparente
        }
        
        // Cambia lo que tenías del padding por esto (es mucho más directo):
        txtFechaInicio.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 1))
        txtFechaInicio.leftViewMode = .always
        
        txtFechaFin.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 1))
        txtFechaFin.leftViewMode = .always
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            return false // No permite escribir nada
        }
    
    @IBAction func btnFiltrar(_ sender: UIButton) {
        guard let ini = txtFechaInicio.text, !ini.isEmpty,
                      let fin = txtFechaFin.text, !fin.isEmpty else { return }
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
            let btnDone = UIBarButtonItem(title: "Hecho", style: .done, target: self, action: #selector(cerrarPicker))
            toolbar.setItems([btnDone], animated: true)
            
            txtFechaInicio.inputAccessoryView = toolbar
            txtFechaFin.inputAccessoryView = toolbar
        }
    
    @objc func fechaInicioCambio() {
            // La fecha fin no puede ser menor a la de inicio
            pickerFin.minimumDate = pickerInicio.date
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
                    case .failure(let error):
                        print("Error: \(error)")
                    }
            }
        }
    }

}
