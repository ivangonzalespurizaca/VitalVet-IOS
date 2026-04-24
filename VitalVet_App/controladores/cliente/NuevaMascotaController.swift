//
//  NuevaMascotaController.swift
//  VitalVet_App
//
//  Created by XCODE on 23/04/26.
//

import UIKit
import Alamofire

class NuevaMascotaController: UIViewControllerProfile ,UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var txtnombreMascota: UITextField!
    
    @IBOutlet weak var pvmascota: UIPickerView!
    
    @IBOutlet weak var txtraza: UITextField!
    
    @IBOutlet weak var segsexo: UISegmentedControl!
    
    @IBOutlet weak var dpfecha: UIDatePicker!
    
    
    @IBOutlet weak var txtpeso: UITextField!
    
    
    let especies = ["CANINO", "FELINO", "OTRO"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            pvmascota.delegate = self
            pvmascota.dataSource = self
            cambiarTitulo(nuevoTexto: "Nueva Mascota")
            segsexo.setTitle("MACHO", forSegmentAt: 0)
            segsexo.setTitle("HEMBRA", forSegmentAt: 1)
            segsexo.selectedSegmentIndex = 0
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1 }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return especies.count
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return especies[row]
        }

   

    
    @IBAction func btnRegistrar(_ sender: UIButton) {
        
        guard let idCliente = UserDefaults.standard.string(forKey: "userId"),
              let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let fechaStr = formatter.string(from: dpfecha.date)
        
        // 3. Crear la instancia de la estructura
        let nuevaMascota = MascotaRequest(
            idCliente: idCliente,
            nombreMascota: txtnombreMascota.text ?? "",
            especie: especies[pvmascota.selectedRow(inComponent: 0)],
            raza: txtraza.text ?? "",
            sexo: (segsexo.selectedSegmentIndex == 0) ? "MACHO" : "HEMBRA",
            fechaNacimiento: fechaStr,
            pesoActual: Double(txtpeso.text ?? "0") ?? 0.0
        )
        
        // 4. URL y Headers
        let url = "https://apiveterinaria-production-238b.up.railway.app/api/mascotas"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        
        AF.request(url,
                   method: .post,
                   parameters: nuevaMascota,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    print("Registro exitoso")
                    self.mostrarAlertaExito()
                case .failure(let error):
                    print("Error en el servidor: \(error)")
                }
            }
    }
    
    func mostrarAlertaExito() {
    
        let alerta = UIAlertController(
            title: "¡Registro Exitoso!",
            message: "La mascota ha sido guardada en el sistema correctamente.",
            preferredStyle: .alert
        )
        
  
        let accionOk = UIAlertAction(title: "Excelente", style: .default) { _ in
        
            if let navigation = self.navigationController {
                navigation.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        // 3. Agregar la acción a la alerta
        alerta.addAction(accionOk)
        
        // 4. Mostrar la alerta en pantalla
        self.present(alerta, animated: true, completion: nil)
    }
    
    
    
    

    

}
