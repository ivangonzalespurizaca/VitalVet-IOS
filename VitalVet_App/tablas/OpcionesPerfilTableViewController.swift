//
//  OpcionesPerfilTableViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 27/04/26.
//

import UIKit
import FirebaseAuth

class OpcionesPerfilTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            switch indexPath.row {
            case 0:
                print("Ir a Datos Personales")
                self.performSegue(withIdentifier: "segueEditarPerfil", sender: nil)
            case 1:
                mostrarAlertaCambioPassword()
            default:
                break
            }
        }
        
    func mostrarAlertaCambioPassword() {
            // 1. Obtenemos el email guardado del usuario
            let emailUsuario = UserDefaults.standard.string(forKey: "userEmail") ?? ""
            
            let alerta = UIAlertController(
                title: "Restablecer Clave",
                message: "Se enviará un correo a \(emailUsuario) con los pasos para cambiar tu contraseña.",
                preferredStyle: .alert
            )
            
            // 2. Conectamos la acción con la función de Firebase
            let accionEnviar = UIAlertAction(title: "Enviar Correo", style: .default) { _ in
                if !emailUsuario.isEmpty {
                    self.enviarSolicitudRecuperacion(email: emailUsuario)
                } else {
                    self.mostrarAlertaError(mensaje: "No se encontró un correo electrónico asociado a esta sesión.")
                }
            }
        
            let accionCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            alerta.addAction(accionEnviar)
            alerta.addAction(accionCancelar)
            
            present(alerta, animated: true)
        }
    
    private func enviarSolicitudRecuperacion(email: String) {
            // Mostramos en consola para debug
            print("Conectando con Firebase para: \(email)")

            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    self.mostrarAlertaError(mensaje: error.localizedDescription)
                    return
                }

                let exito = UIAlertController(
                    title: "Correo Enviado",
                    message: "Hemos enviado un enlace de recuperación a \(email). Por favor, revisa tu bandeja de entrada.",
                    preferredStyle: .alert
                )
                exito.addAction(UIAlertAction(title: "Entendido", style: .default))
                self.present(exito, animated: true)
            }
        }

    private func mostrarAlertaError(mensaje: String) {
        let alerta = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        self.present(alerta, animated: true)
    }
}
