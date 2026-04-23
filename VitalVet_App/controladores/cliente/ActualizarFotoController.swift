//
//  ActualizarFotoController.swift
//  VitalVet_App
//
//  Created by XCODE on 23/04/26.
//

import UIKit
import Alamofire

class ActualizarFotoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource {
   
    

    var idMascota: Int?
    @IBOutlet weak var imgPreview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvvacunas.dataSource = self
        tvvacunas.delegate = self
        tvvacunas.rowHeight = 120
                
                // Llamamos a la API si tenemos el ID de la mascota
        if let id = idMascota {
            cargarCarnetVacunas(idMascota: id)
        }
    }

    @IBAction func btnSeleccionarFoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagenSeleccionada = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            self.imgPreview.image = imagenSeleccionada
            print("Imagen cargada en el preview")
        } else {
            print("No se pudo recuperar la imagen")
        }
        
        picker.dismiss(animated: true)
    }

    @IBAction func btnSubirFoto(_ sender: UIButton) {
        guard let imagen = imgPreview.image, let id = idMascota else { return }
        subirImagenAlServidor(imagen: imagen, idMascota: id)
    }

    func subirImagenAlServidor(imagen: UIImage, idMascota: Int) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        
        let url = "https://apiveterinaria-production-238b.up.railway.app/api/mascotas/\(idMascota)/foto"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]

        guard let imageData = imagen.jpegData(compressionQuality: 0.7) else { return }

    
        AF.upload(multipartFormData: { multipartFormData in
        
            multipartFormData.append(imageData, withName: "archivo", fileName: "mascota_\(idMascota).jpg", mimeType: "image/jpeg")
        }, to: url, method: .patch, headers: headers)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Foto actualizada con éxito: \(value)")
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print("Error al subir: \(error)")
            }
        }
    }
    
    //parte de la tabla
    @IBOutlet weak var tvvacunas: UITableView!
    
    var listaVacunas: [VacunaAplicada] = []
    
    

    func cargarCarnetVacunas(idMascota: Int) {
            guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
            
            let url = "https://apiveterinaria-production-238b.up.railway.app/api/vacunas-aplicadas/mascota/\(idMascota)/carnet"
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Accept": "application/json"
            ]
            
            AF.request(url, method: .get, headers: headers)
                .validate()
                .responseDecodable(of: [VacunaAplicada].self) { response in
                    switch response.result {
                    case .success(let vacunas):
                        self.listaVacunas = vacunas
                        DispatchQueue.main.async {
                            self.tvvacunas.reloadData()
                        }
                    case .failure(let error):
                        print("Error al obtener el carnet: \(error.localizedDescription)")
                    }
                }
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return listaVacunas.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! celdaVacunas
            let vacuna = listaVacunas[indexPath.row]
            
        
            cell.txtnomvacuna.text = vacuna.nombreVacuna
            cell.txtveterinario.text = vacuna.nombreVeterinario
            cell.txtEstado.text = vacuna.estado
            
            return cell
        }
    
}


