//
//  RegistrarVeterinarioViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 24/04/26.
//

import UIKit
import FirebaseAuth

class RegistrarVeterinarioViewController: UIViewControllerProfile, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listaEspecialidades.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listaEspecialidades[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtEspecialidad.text = listaEspecialidades[row]
    }
    
    var listaEspecialidades: [String] = []
    
    var nombresProv: String?
    var apellidosProv: String?
    var generoProv: String?
    var dniProv: String?
    
    @IBOutlet weak var txtCelular: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtEspecialidad: UITextField!
    @IBOutlet weak var pvEspecialidad: UIPickerView!
    @IBOutlet weak var txtColegiatura: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        cambiarTitulo(nuevoTexto: "Parte 2 de 2")
        
        // Configuración de delegados del Picker
        pvEspecialidad.delegate = self
        pvEspecialidad.dataSource = self
        
        // 1. Configurar Iconos y Estilo (SF Symbols)
        txtEmail.configurarEstiloVitalVet(icono: "envelope.fill", placeholder: "Correo Electrónico")
        txtCelular.configurarEstiloVitalVet(icono: "phone.fill", placeholder: "Número de Celular")
        txtEspecialidad.configurarEstiloVitalVet(icono: "briefcase.fill", placeholder: "Seleccionar Especialidad")
        txtColegiatura.configurarEstiloVitalVet(icono: "person.text.rectangle.fill", placeholder: "Número de Colegiatura (CMVP)")
        
        // 2. Asignar Picker como entrada para Especialidad y ocultar cursor
        txtEspecialidad.inputView = pvEspecialidad
        txtEspecialidad.tintColor = .clear
        
        // 3. Agregar Toolbar para poder cerrar el Picker
        configurarToolbar(para: txtEspecialidad)
        
        cargarEspecialidades()
    }
    
    private func cargarEspecialidades() {
        EnumService().obtenerEspecialidades { [weak self] lista in
            if let lista = lista {
                self?.listaEspecialidades = lista
                // Forzamos la actualización del picker
                DispatchQueue.main.async { self?.pvEspecialidad.reloadAllComponents() }
            }
        }
    }

    @IBAction func btnRegistrar(_ sender: Any) {
        guard let email = txtEmail.text, !email.isEmpty,
              let password = dniProv, password.count >= 6,
              let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("Error: Datos incompletos o password muy corto")
            return
        }

        // 1. Registro en Firebase Auth
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.mostrarAlerta(mensaje: "Error Firebase: \(error.localizedDescription)", title: "Error")
                return
            }

            guard let user = authResult?.user else { return }
            let uid = user.uid

            // 2. Registro en Railway con el UID de Firebase
            let datosFinales = VeterinarioRegister(
                idUsuario: uid,
                nombres: self.nombresProv ?? "",
                apellidos: self.apellidosProv ?? "",
                email: email,
                dni: self.dniProv ?? "",
                celular: self.txtCelular.text ?? "",
                genero: self.generoProv ?? "",
                numColegiatura: self.txtColegiatura.text ?? "",
                especialidad: self.txtEspecialidad.text ?? ""
            )

            VeterinarioService.shared.registrarVeterinario(datos: datosFinales, token: token) { resultado in
                switch resultado {
                case .success:
                    // Creamos la alerta
                    let alerta = UIAlertController(title: "VitalVet", message: "¡Veterinario registrado con éxito!", preferredStyle: .alert)
                    let accionOk = UIAlertAction(title: "Aceptar", style: .default) { _ in
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    alerta.addAction(accionOk)
                    self.present(alerta, animated: true)
                    case .failure(let error):
                    user.delete { errorDelete in
                        if let errorDelete = errorDelete {
                            print("Error crítico: No se pudo limpiar Firebase -> \(errorDelete.localizedDescription)")
                        } else {
                            print("Rollback exitoso: Usuario de Firebase eliminado para mantener consistencia.")
                        }
                        
                        // Mostramos el error original de Railway al usuario
                        self.mostrarAlerta(mensaje: "No se pudo completar el registro médico: \(error.localizedDescription)", title: "Error de Servidor")
                    }
                }
            }
        }
    }
    
    private func configurarToolbar(para textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Estilo de la barra (puedes usar el azul de tu app)
        toolbar.barTintColor = .white
        toolbar.isTranslucent = false
        
        let btnDone = UIBarButtonItem(title: "Hecho", style: .prominent, target: self, action: #selector(cerrarPicker))
        let espacio = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        btnDone.tintColor = UIColor.lightGray
        
        toolbar.setItems([espacio, btnDone], animated: false)
        textField.inputAccessoryView = toolbar
    }

    @objc func cerrarPicker() {
        view.endEditing(true)
    }
    
    private func mostrarAlerta(mensaje: String, title: String) {
        let alerta = UIAlertController(title: title, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alerta, animated: true)
    }
    

}
