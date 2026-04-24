//
//  NuevoVeterinarioViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 24/04/26.
//

import UIKit

class NuevoVeterinarioViewController: UIViewControllerProfile, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtGenero: UITextField!
    @IBOutlet weak var txtDNI: UITextField!
    @IBOutlet weak var pvGenero: UIPickerView!
    
    var listaGeneros: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        cambiarTitulo(nuevoTexto: "Datos Personales")
        
        // Configuración básica del Picker
        pvGenero.delegate = self
        pvGenero.dataSource = self
        // Llamada al servicio para traer los géneros desde Railway
        cargarGenerosDesdeAPI()
        
        // Configurar gesto para cerrar el teclado/picker al tocar fuera
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(tap)
    }

    func cargarGenerosDesdeAPI() {
        EnumService().obtenerGeneros { [weak self] generosObtenidos in
            if let lista = generosObtenidos {
                self?.listaGeneros = lista
                // Importante: Actualizar el picker en el hilo principal
                DispatchQueue.main.async {
                    self?.pvGenero.reloadAllComponents()
                }
            }else{
                print("DEBUG: No se recibieron géneros de la API")
            }
        }
    }

    // MARK: - UIPickerView DataSource & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listaGeneros.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Opcional: .capitalized para que no salga todo en mayúsculas
        return listaGeneros[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Guardamos el valor tal cual (ej: "MASCULINO") para que el backend lo entienda
        txtGenero.text = listaGeneros[row]
    }

    // MARK: - Navegación a Pantalla 2
    @IBAction func btnSiguiente(_ sender: Any) {
        guard let nom = txtNombre.text, !nom.isEmpty,
              let ape = txtApellido.text, !ape.isEmpty,
              let gen = txtGenero.text, !gen.isEmpty,
              let dni = txtDNI.text, !dni.isEmpty else {
            // Aquí puedes poner una alerta de "Campos obligatorios"
            return
        }
        
        performSegue(withIdentifier: "segueRegistrarVet", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueRegistrarVet" {
            if let destino = segue.destination as? RegistrarVeterinarioViewController {
                destino.nombresProv = txtNombre.text
                destino.apellidosProv = txtApellido.text
                destino.generoProv = txtGenero.text
                destino.dniProv = txtDNI.text
            }
        }
    }
}
