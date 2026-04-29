//
//  RegistroViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 22/04/26.
//

import UIKit

class RegistroCuentaViewController: UIViewControllerProfile {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtContrasenia: UITextField!
    @IBOutlet weak var txtRepContrasenia: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Configurar Email
        txtEmail.configurarEstiloVitalVet(
            icono: "envelope.fill",
            placeholder: "Correo electrónico"
        )
        
        // 2. Configurar Contraseña
        txtContrasenia.configurarEstiloVitalVet(
            icono: "lock.fill",
            placeholder: "Contraseña"
        )
        txtContrasenia.isSecureTextEntry = true
        
        // 3. Configurar Repetir Contraseña
        txtRepContrasenia.configurarEstiloVitalVet(
            icono: "lock.shield.fill", 
            placeholder: "Confirmar contraseña"
        )
        txtRepContrasenia.isSecureTextEntry = true
        
        cambiarTitulo(nuevoTexto: "Paso 1 de 2")
        
        self.imgPerfil.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueRegistrarPerfil" {
            if let pantallaDestino = segue.destination as? RegistroPerfilViewController {
                
                pantallaDestino.emailRecibido = txtEmail.text
                pantallaDestino.passwordRecibido = txtContrasenia.text
            }
        }
    }
    
    
    @IBAction func btnSeguiente(_ sender: Any) {
        // 1. Obtener los textos limpios
        guard let email = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              let pass = txtContrasenia.text,
              let repPass = txtRepContrasenia.text else { return }

        // 2. Validar que no haya campos vacíos
        if email.isEmpty || pass.isEmpty || repPass.isEmpty {
            mostrarAlerta(mensaje: "Por favor, completa todos los campos.")
            return
        }

        // 3. Validar formato de Email
        if !validarEmail(email) {
            mostrarAlerta(mensaje: "El formato del correo electrónico no es válido.")
            return
        }

        // 4. Validar que las contraseñas coincidan
        if pass != repPass {
            mostrarAlerta(mensaje: "Las contraseñas no coinciden.")
            return
        }
        
        // 5. Validar largo de contraseña (Firebase pide mínimo 6)
        if pass.count < 6 {
            mostrarAlerta(mensaje: "La contraseña debe tener al menos 6 caracteres.")
            return
        }

        // Si todo está bien, pasamos al siguiente paso
        performSegue(withIdentifier: "segueRegistrarPerfil", sender: self)
    }
    
    private func mostrarAlerta(mensaje: String) {
        let alerta = UIAlertController(title: "VitalVet", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alerta, animated: true)
    }
    
    func validarEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

}
