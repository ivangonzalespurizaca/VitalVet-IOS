//
//  UIViewControllerProfile.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 21/04/26.
//

import UIKit
import Kingfisher

class UIViewControllerProfile: UIViewController {
    
    let imgPerfil = UIImageView()
    let lblSaludo = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderBase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actualizarDatosHeader()
    }
    
    private func setupHeaderBase() {
        // 1. Configuración de la Foto (Mantenemos a la derecha)
        imgPerfil.frame = CGRect(x: view.frame.width - 70, y: 60, width: 50, height: 50)
        imgPerfil.layer.cornerRadius = 25
        imgPerfil.clipsToBounds = true
        imgPerfil.isUserInteractionEnabled = true
        imgPerfil.contentMode = .scaleAspectFill
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(irAEditarPerfil))
        imgPerfil.addGestureRecognizer(tap)
        
        // 2. Configuración del Texto (CENTRADO)
        // Usamos todo el ancho de la pantalla para que el centro sea real
        lblSaludo.frame = CGRect(x: 0, y: 60, width: view.frame.width, height: 50)
        lblSaludo.textAlignment = .center // <--- Magia del centro
        lblSaludo.font = UIFont.boldSystemFont(ofSize: 18)
        
        view.addSubview(lblSaludo)
        view.addSubview(imgPerfil) // La foto va encima por si el texto es muy largo
        
        view.bringSubviewToFront(imgPerfil)
        view.bringSubviewToFront(lblSaludo)
        
        actualizarDatosHeader()
    }

    func actualizarDatosHeader() {
        let defaults = UserDefaults.standard
        let nombre = defaults.string(forKey: "userNombre") ?? "Usuario"
        lblSaludo.text = "¡Hola, \(nombre)!"
        
        if var urlStr = defaults.string(forKey: "userFotoUrl") {
            if urlStr.hasPrefix("http://") {
                urlStr = urlStr.replacingOccurrences(of: "http://", with: "https://")
            }
            
            if let url = URL(string: urlStr) {
                imgPerfil.kf.setImage(
                    with: url,
                    placeholder: UIImage(systemName: "person.circle.fill"),
                    options: [.transition(.fade(0.3))]
                )
            }
        } else {
            imgPerfil.image = UIImage(systemName: "person.circle.fill")
        }
    }

    // FUNCIÓN PARA CAMBIAR EL TEXTO DESDE OTROS LADOS
    func cambiarTitulo(nuevoTexto: String) {
        lblSaludo.text = nuevoTexto
    }

    @objc func irAEditarPerfil() {
        if let perfilVC = storyboard?.instantiateViewController(withIdentifier: "PerfilUsuarioViewController") {
                self.navigationController?.pushViewController(perfilVC, animated: true)
            }
    }
}
