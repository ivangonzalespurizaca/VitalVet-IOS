//
//  ViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 19/04/26.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtContrasenia: UITextField!
    
    let authService = AuthService()

    override func viewDidLoad() {
        super.viewDidLoad()
        //txtContrasenia.isSecureTextEntry = true
    }
    
    @IBAction func btnIniciarSesion(_ sender: Any) {
        // A. Validar que los campos no estén vacíos
        guard let email = txtEmail.text, !email.isEmpty,
              let password = txtContrasenia.text, !password.isEmpty else {
            print("Por favor completa todos los campos.")
            return
        }
            
        print("Intentando iniciar sesión para: \(email)")
            
        authService.loginYSync(email: email, password: password) { resultado in
            
            // C. Manejar la respuesta (Importante: Ejecutar en el hilo principal)
            DispatchQueue.main.async {
                switch resultado {
                case .success(let usuarioInfo):
                    print("Bienvenido: \(usuarioInfo.nombres)")
                    self.navegarSegunRol(usuario: usuarioInfo)
                    
                case .failure(let error):
                    print("Error de login: \(error.localizedDescription)")
                    // Mostrar alerta de error al usuario
                    self.mostrarAlerta(mensaje: "Credenciales incorrectas o problema de conexión.")
                }
            }
        }
    }
    
    @IBAction func btnCrearCuenta(_ sender: Any) {
        performSegue(withIdentifier: "segueRegistrarCuenta", sender: nil)
    }
    
    
    private func navegarSegunRol(usuario: UsuarioInfoDTO) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rolStr = usuario.rol.uppercased()
        
        var identifier = ""
        
        switch rolStr {
        case "ADMINISTRADOR":
            identifier = "TabBarAdmin"
        case "VETERINARIO":
            identifier = "TabBarVet"
        case "CLIENTE":
            identifier = "TabBarCliente"
        default:
            print("El usuario no tiene un rol válido definido.")
            self.mostrarAlerta(mensaje: "Tu usuario no tiene acceso configurado.")
            return
        }
        
        // Intentamos instanciar el controlador de pestañas
        if let portalVC = storyboard.instantiateViewController(withIdentifier: identifier) as? UITabBarController {
            portalVC.modalPresentationStyle = .fullScreen
            portalVC.modalTransitionStyle = .crossDissolve // Una transición suave
            
            // El gran salto al Portal
            self.present(portalVC, animated: true, completion: nil)
        } else {
            print("Error: No se encontró el Storyboard ID '\(identifier)'")
            self.mostrarAlerta(mensaje: "Error interno: Interfaz no encontrada.")
        }
    }
    
    private func mostrarAlerta(mensaje: String) {
        let alerta = UIAlertController(title: "VitalVet", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alerta, animated: true)
    }

}

