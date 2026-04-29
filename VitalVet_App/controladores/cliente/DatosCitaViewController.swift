//
//  DatosCitaViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 26/04/26.
//

import Kingfisher
import UIKit

class DatosCitaViewController: UIViewController {
    
    
    
    @IBOutlet weak var btnCancelar: UIButton!
    @IBOutlet weak var imgMascota: UIImageView!
    @IBOutlet weak var lblEstadoCita: UILabel!
    @IBOutlet weak var lblNombreMascota: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblHora: UILabel!
    @IBOutlet weak var lblNombreVeterinario: UILabel!
    @IBOutlet weak var lblEspecialidad: UILabel!
    @IBOutlet weak var lblNombreCliente: UILabel!
    @IBOutlet weak var lblCelularCliente: UILabel!
    @IBOutlet weak var lblMotivo: UILabel!
    
    var cita: CitaInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarDatos()
        configurarUI() 
    }
    
    func configurarDatos() {
        guard let c = cita else { return }
        
        // Asignación de textos con prefijos
            lblNombreMascota.text = "Mascota: \(c.nombreMascota)"
            lblEstadoCita.text = c.estado.uppercased()
            lblFecha.text = "Fecha: \(c.fecha)"
            lblHora.text = "Hora: \(c.hora.prefix(5))"
            lblNombreVeterinario.text = "Veterinario: Dr. \(c.nombreVeterinario)"
            lblEspecialidad.text = "Especialidad: \(c.especialidadVeterinario.replacingOccurrences(of: "_", with: " "))"
            lblNombreCliente.text = "Dueño: \(c.nombreCliente)"
            lblCelularCliente.text = "Celular: \(c.celularCliente)"
            lblMotivo.text = "Motivo: \(c.motivo)"
            
            // Cargar imagen de la mascota con Kingfisher
            if let urlString = c.fotoMascotaUrl, let url = URL(string: urlString) {
                imgMascota.kf.setImage(
                    with: url,
                    placeholder: UIImage(systemName: "pawprint.circle.fill"), // Imagen mientras carga
                    options: [.transition(.fade(0.3))] // Efecto suave al aparecer
                )
            } else {
                imgMascota.image = UIImage(systemName: "pawprint.circle.fill")
            }
            
            // Estilo del Estado
            configurarColorEstado(c.estado)
        
        // Lógica del botón: Solo habilitar si es cancelable
        let esCancelable = (c.estado == "PENDIENTE" || c.estado == "CONFIRMADA")
        btnCancelar.isHidden = !esCancelable
    }
    
    private func configurarUI() {
        // 1. Diseño de la imagen (Círculo con borde sutil)
        imgMascota.layer.cornerRadius = imgMascota.frame.height / 2
        imgMascota.layer.borderWidth = 3
        imgMascota.layer.borderColor = UIColor.systemGray6.cgColor
        imgMascota.clipsToBounds = true
        
        // 2. Diseño del Label de Estado (Tipo Badge/Etiqueta)
        lblEstadoCita.layer.cornerRadius = 8
        lblEstadoCita.clipsToBounds = true
        lblEstadoCita.font = .systemFont(ofSize: 14, weight: .bold)
        // Agregamos un poco de "padding" visual si es posible en tu layout
        
        // 3. Estilo del Botón Cancelar
        btnCancelar.layer.cornerRadius = 12
        btnCancelar.backgroundColor = .systemRed.withAlphaComponent(0.1)
        btnCancelar.setTitleColor(.systemRed, for: .normal)
        btnCancelar.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        
        // 4. Jerarquía visual en textos
        lblNombreMascota.font = .systemFont(ofSize: 22, weight: .bold)
        lblNombreVeterinario.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private func configurarColorEstado(_ estado: String) {
        switch estado.uppercased() {
        case "PENDIENTE": lblEstadoCita.textColor = .systemOrange
        case "CONFIRMADA": lblEstadoCita.textColor = .systemGreen
        case "CANCELADA": lblEstadoCita.textColor = .systemRed
        default: lblEstadoCita.textColor = .systemGray
        }
    }
    
    @IBAction func btnCancelar(_ sender: Any) {
        let alerta = UIAlertController(title: "Cancelar Cita",
                                          message: "Por favor, ingresa el motivo de la cancelación (mínimo 10 caracteres).",
                                          preferredStyle: .alert)
            
            alerta.addTextField { textField in
                textField.placeholder = "Motivo de cancelación..."
            }
            
            let accionConfirmar = UIAlertAction(title: "Confirmar", style: .destructive) { _ in
                if let motivoTexto = alerta.textFields?.first?.text, motivoTexto.count >= 10 {
                    // Pasamos el motivo a la función de ejecución
                    self.ejecutarCancelacion(motivo: motivoTexto)
                } else {
                    // Opcional: mostrar un error si es muy corto
                    print("El motivo es demasiado corto")
                }
            }
            
            alerta.addAction(accionConfirmar)
            alerta.addAction(UIAlertAction(title: "Volver", style: .cancel))
            
            present(alerta, animated: true)
    }
    
    private func ejecutarCancelacion(motivo: String) { // Agregamos el parámetro aquí
        guard let idCita = cita?.idCita,
              let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        
        // Ahora enviamos el motivo al CitaService
        CitaService.shared.cancelarCita(idCita: idCita, motivo: motivo, token: token) { [weak self] resultado in
            DispatchQueue.main.async {
                switch resultado {
                case .success:
                    let exito = UIAlertController(title: "Cancelada", message: "La cita ha sido cancelada correctamente.", preferredStyle: .alert)
                    exito.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self?.navigationController?.popViewController(animated: true)
                    }))
                    self?.present(exito, animated: true)
                    
                case .failure(let error):
                    let errorAlerta = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    errorAlerta.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(errorAlerta, animated: true)
                }
            }
        }
    }
    

}
