//
//  EditarVeterinarioViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 24/04/26.
//

import UIKit
import Kingfisher

class EditarVeterinarioViewController: UIViewControllerProfile, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listaEspecialidades.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listaEspecialidades[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtEspecialidad.text = listaEspecialidades[row]
    }
    
    @IBOutlet weak var lblNombresCompletos: UILabel!
    @IBOutlet weak var lblDni: UILabel!
    @IBOutlet weak var lblGenero: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblCelular: UILabel!
    
    @IBOutlet weak var txtNumeroColegiatura: UITextField!
    @IBOutlet weak var txtEspecialidad: UITextField!
    @IBOutlet weak var pvEspecialidad: UIPickerView!
    @IBOutlet weak var swActivo: UISwitch!
    @IBOutlet weak var imgVet: UIImageView!
    
    var veterinarioSeleccionado: VeterinarioInfo?
    var listaEspecialidades: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Configurar Título y Pickers
        cambiarTitulo(nuevoTexto: "Editar Veterinario")
        pvEspecialidad.delegate = self
        pvEspecialidad.dataSource = self
        txtEspecialidad.inputView = pvEspecialidad
        
        // 2. Configurar Iconos y Estilo VitalVet
        // Usamos 'briefcase.fill' para especialidad y 'idcard.fill' para colegiatura
        txtEspecialidad.configurarEstiloVitalVet(icono: "briefcase.fill", placeholder: "Especialidad")
        txtNumeroColegiatura.configurarEstiloVitalVet(icono: "person.text.rectangle.fill", placeholder: "Nro. Colegiatura")
        
        // 3. Estética de la imagen (Círculo)
        configurarImagenPerfil()
        
        // 4. Barras de herramientas y carga de datos
        configurarToolbar(para: txtEspecialidad)
        cargarEspecialidades()
        completarCampos()
        
        // 5. Ocultar cursor en especialidad
        txtEspecialidad.tintColor = .clear
    }
    
    private func configurarImagenPerfil() {
        imgVet.layer.cornerRadius = imgVet.frame.height / 2
        imgVet.clipsToBounds = true
        imgVet.contentMode = .scaleAspectFill
        imgVet.layer.borderWidth = 2
        imgVet.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.3).cgColor
    }
    
    @IBAction func btnGuardar(_ sender: Any) {
        guard let vet = veterinarioSeleccionado,
              let token = UserDefaults.standard.string(forKey: "userToken") else {
            self.mostrarAlerta(mensaje: "Sesión expirada o datos incompletos. Intente reingresar.", title: "Atención")
            return
        }

        let datosActualizados = VeterinarioUpdate(
            numColegiatura: txtNumeroColegiatura.text ?? "",
            especialidad: txtEspecialidad.text ?? "",
            activo: swActivo.isOn
        )

        // Mostrar un indicador de carga si tienes uno (opcional)
        VeterinarioService.shared.actualizarVeterinario(id: vet.idVeterinario!, datos: datosActualizados, token: token) { [weak self] resultado in
            
            DispatchQueue.main.async {
                switch resultado {
                case .success:
                    self?.mostrarAlertaExito()
                    
                case .failure(let error):
                    // Extraemos el mensaje del NSError o del enum de error
                    let mensajeError = error.localizedDescription
                    self?.mostrarAlerta(mensaje: mensajeError, title: "No se pudo actualizar")
                    print("DEBUG: Error al actualizar -> \(mensajeError)")
                }
            }
        }
    }

    // Función auxiliar para mejorar la experiencia de usuario
    func mostrarAlertaExito() {
        let alerta = UIAlertController(title: "¡Éxito!", message: "Los datos del veterinario se actualizaron correctamente.", preferredStyle: .alert)
        let accionOk = UIAlertAction(title: "OK", style: .default) { _ in
            // Regresa a la pantalla del listado
            self.navigationController?.popViewController(animated: true)
        }
        alerta.addAction(accionOk)
        present(alerta, animated: true)
    }
    
    private func mostrarAlerta(mensaje: String, title: String) {
        let alerta = UIAlertController(title: title, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alerta, animated: true)
    }
    
    func completarCampos() {
        // Verificamos que el objeto no sea nulo
        guard let vet = veterinarioSeleccionado else { return }
        
        // Llenamos los labels (Datos fijos)
        lblNombresCompletos.text = "\(vet.nombres) \(vet.apellidos)"
        lblDni.text = "DNI: \(vet.dni)"
        lblEmail.text = vet.email
        // Llenamos los campos para editar
        txtNumeroColegiatura.text = vet.numColegiatura
        txtEspecialidad.text = vet.especialidad
        swActivo.isOn = vet.activo ?? true
    
        if var urlStr = vet.fotoUrl {
            if urlStr.hasPrefix("http://") {
                urlStr = urlStr.replacingOccurrences(of: "http://", with: "https://")
            }
            
            if let url = URL(string: urlStr) {
                imgVet.kf.setImage(with: url, placeholder: UIImage(systemName: "person.circle.fill"))
            }
        } else {
            imgVet.image = UIImage(systemName: "person.circle.fill")
        }
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
    
    private func configurarToolbar(para textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let btnDone = UIBarButtonItem(title: "Hecho", style: .prominent, target: self, action: #selector(cerrarPicker))
        let espacio = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([espacio, btnDone], animated: false)
        textField.inputAccessoryView = toolbar
    }

    @objc func cerrarPicker() {
        view.endEditing(true)
    }
    

}
