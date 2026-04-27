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
        pvEspecialidad.delegate = self
        pvEspecialidad.dataSource = self
        cambiarTitulo(nuevoTexto: "Editar Veterinario")
        cargarEspecialidades()
        txtEspecialidad.inputView = pvEspecialidad
        completarCampos()

    }
    
    @IBAction func btnGuardar(_ sender: Any) {
        // 1. Validamos que tengamos al veterinario y el token de sesión
        guard let vet = veterinarioSeleccionado,
              let token = UserDefaults.standard.string(forKey: "userToken") else {
            print("Error: No hay datos del veterinario o token.")
            return
        }

        let datosActualizados = VeterinarioUpdate(
            numColegiatura: txtNumeroColegiatura.text ?? "",
            especialidad: txtEspecialidad.text ?? "",
            activo: swActivo.isOn
        )

        VeterinarioService.shared.actualizarVeterinario(id: vet.idVeterinario!, datos: datosActualizados, token: token) { [weak self] resultado in
            
            // Siempre volvemos al hilo principal para tocar la interfaz
            DispatchQueue.main.async {
                switch resultado {
                case .success:
                    self?.mostrarAlertaExito()
                case .failure(let error):
                    print("Error al actualizar: \(error.localizedDescription)")
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
    
    func completarCampos() {
        // Verificamos que el objeto no sea nulo
        guard let vet = veterinarioSeleccionado else { return }
        
        // Llenamos los labels (Datos fijos)
        lblNombresCompletos.text = "\(vet.nombres) \(vet.apellidos)"
        lblDni.text = "DNI: \(vet.dni)"
        lblEmail.text = "EMAIL: \(vet.email)"
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
    

}
