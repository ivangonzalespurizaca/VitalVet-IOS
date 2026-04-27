//
//  PerfilUsuarioViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 27/04/26.
//

import UIKit
import Kingfisher

class PerfilUsuarioViewController: UIViewControllerProfile {
    
    @IBOutlet weak var imgFotoPerfil: UIImageView!
    @IBOutlet weak var lblNombreCompleto: UILabel!
    @IBOutlet weak var lblCorreo: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        cambiarTitulo(nuevoTexto: "MI PERFIL")
        self.imgPerfil.isHidden = true
        configurarDatosUsuario()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configurarDatosUsuario()
    }
    
    func configurarDatosUsuario() {
        let defaults = UserDefaults.standard
        
        // Recuperamos los datos guardados en el Login
        let nombre = defaults.string(forKey: "userNombre") ?? "Usuario"
        let apellido = defaults.string(forKey: "userApellidos") ?? ""
        let email = defaults.string(forKey: "userEmail") ?? "correo@ejemplo.com"
        
        // Asignamos a los Labels
        lblNombreCompleto.text = "\(nombre) \(apellido)"
        lblCorreo.text = email
        
        // Configuramos la foto circular
        imgFotoPerfil.layer.cornerRadius = imgFotoPerfil.frame.height / 2
        imgFotoPerfil.clipsToBounds = true
        imgFotoPerfil.contentMode = .scaleAspectFill
        
        if var urlStr = defaults.string(forKey: "userFotoUrl") {
            if urlStr.hasPrefix("http://") {
                urlStr = urlStr.replacingOccurrences(of: "http://", with: "https://")
            }
            
            if let url = URL(string: urlStr) {
                imgFotoPerfil.kf.setImage(
                    with: url,
                    placeholder: UIImage(systemName: "person.circle.fill"),
                    options: [.forceRefresh,
                              .transition(.fade(0.3))] // Efecto suave al aparecer
                )
            }
        } else {
            imgFotoPerfil.image = UIImage(systemName: "person.circle.fill")
        }
    }
    
    @IBAction func btnCerrarSesion(_ sender: Any) {
        let alerta = UIAlertController(title: "¿Cerrar Sesión?",
                                       message: "¿Estás seguro de que deseas salir de VitalVet?",
                                       preferredStyle: .alert)
        
        let accionSalir = UIAlertAction(title: "Salir", style: .destructive) { _ in
            self.procesarSalida()
        }
        
        let accionCancelar = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alerta.addAction(accionSalir)
        alerta.addAction(accionCancelar)
        
        present(alerta, animated: true)
    }
    
    private func procesarSalida() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
        
        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "ViewController") {
            loginVC.modalPresentationStyle = .fullScreen
            
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = loginVC
                UIView.transition(with: sceneDelegate.window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        }
    }
}
