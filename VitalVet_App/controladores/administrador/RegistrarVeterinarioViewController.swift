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
        cambiarTitulo(nuevoTexto: "Nuevo Veterinario")
        
        pvEspecialidad.delegate = self
        pvEspecialidad.dataSource = self
        
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
                print("Error Firebase: \(error.localizedDescription)")
                return
            }

            guard let uid = authResult?.user.uid else { return }

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
                    self.mostrarAlerta(mensaje: "Error Railway: \(error.localizedDescription)", title: "Error")
                }
            }
        }
    }
    
    private func mostrarAlerta(mensaje: String, title: String) {
        let alerta = UIAlertController(title: title, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alerta, animated: true)
    }
    

}
