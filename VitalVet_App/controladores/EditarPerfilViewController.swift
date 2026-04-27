//
//  EditarPerfilViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 27/04/26.
//

import UIKit
import Kingfisher
import PhotosUI

class EditarPerfilViewController: UIViewControllerProfile, PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
                
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
                
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let self = self, let uiImage = image as? UIImage else { return }
            
            DispatchQueue.main.async {
                self.imgFotoPerfil.image = uiImage
                
                // 2. Llamada al servicio PATCH
                let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
                AuthService.shared.actualizarFoto(userId: userId, imagen: uiImage) { result in
                    switch result {
                    case .success(let nuevaUrl):
                        print("Foto actualizada con éxito: \(nuevaUrl)")
                    case .failure(let error):
                        print("Error subiendo foto: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var imgFotoPerfil: UIImageView!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtDni: UITextField!
    @IBOutlet weak var txtNombres: UITextField!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtCelular: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        cambiarTitulo(nuevoTexto: "Editar Perfil")
        self.imgPerfil.isHidden = true
        
        cargarDatosActuales()
        configurarUI()
    }
    
    func configurarUI() {
        // Bloqueamos Correo y DNI para que sean solo lectura
        txtCorreo.isEnabled = false
        txtCorreo.alpha = 0.7
        txtDni.isEnabled = false
        txtDni.alpha = 0.7
        
        // Estética de la foto
        imgFotoPerfil.layer.cornerRadius = imgFotoPerfil.frame.height / 2
        imgFotoPerfil.clipsToBounds = true
        imgFotoPerfil.contentMode = .scaleAspectFill
    }
    
    func cargarDatosActuales() {
        let defaults = UserDefaults.standard
        
        // Rellenamos los campos con lo que tenemos en UserDefaults
        txtNombres.text = defaults.string(forKey: "userNombre")
        txtApellidos.text = defaults.string(forKey: "userApellidos")
        txtCelular.text = defaults.string(forKey: "userCelular") // Si lo guardaste en el login
        
        txtCorreo.text = defaults.string(forKey: "userEmail")
        txtDni.text = defaults.string(forKey: "userDni")
        
        if var urlStr = defaults.string(forKey: "userFotoUrl") {
            if urlStr.hasPrefix("http://") {
                urlStr = urlStr.replacingOccurrences(of: "http://", with: "https://")
            }
            
            if let url = URL(string: urlStr) {
                imgFotoPerfil.kf.setImage(
                    with: url,
                    placeholder: UIImage(systemName: "person.circle.fill"),
                    options: [.transition(.fade(0.3))] // Efecto suave al aparecer
                )
            }
        } else {
            imgFotoPerfil.image = UIImage(systemName: "person.circle.fill")
        }
    }
    
    @IBAction func btnCambiarFoto(_ sender: Any) {
        var config = PHPickerConfiguration()
            config.filter = .images
            config.selectionLimit = 1
            
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            present(picker, animated: true)
    }
    
    
    @IBAction func btnGuardarCambios(_ sender: Any) {
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
                
        // Creamos el DTO con la info de los campos
        let datosUpdate = UsuarioUpdateDTO(
            nombres: txtNombres.text ?? "",
            apellidos: txtApellidos.text ?? "",
            celular: txtCelular.text ?? "",
            genero: UserDefaults.standard.string(forKey: "userGenero") ?? "MASCULINO"
        )
        
        // Llamada al servicio PUT
        AuthService.shared.actualizarDatosUsuario(userId: userId, datos: datosUpdate) { exito in
            if exito {
                // Alerta de éxito y volver atrás
                let alerta = UIAlertController(title: "¡Éxito!", message: "Tus datos han sido actualizados correctamente.", preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alerta, animated: true)
            } else {
                print("Error al actualizar datos")
            }
        }
    }
    
    

}
