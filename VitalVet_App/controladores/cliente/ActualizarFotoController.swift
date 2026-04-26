import UIKit
import Alamofire

class ActualizarFotoController: UIViewControllerProfile, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var idMascota: Int?
    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var tvvacunas: UITableView!
    
    var listaVacunas: [VacunaAplicada] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cambiarTitulo(nuevoTexto: "Actualizar Mascota")
        
        tvvacunas.dataSource = self
        tvvacunas.delegate = self
        tvvacunas.rowHeight = 120
        
        // Estado inicial de la foto
        actualizarMensajeFoto()
        
        if let id = idMascota {
            cargarCarnetVacunas(idMascota: id)
        }
    }

    // MARK: - Gestión de Imagen
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
            actualizarMensajeFoto() // Quitamos el mensaje al seleccionar foto
        }
        picker.dismiss(animated: true)
    }

    func actualizarMensajeFoto() {
        let tagMensaje = 999
        let mensajeExistente = view.viewWithTag(tagMensaje)
        
        // Si no hay imagen en el preview
        if imgPreview.image == nil {
            if mensajeExistente == nil {
                let lbl = UILabel()
                lbl.text = "Selecciona una foto para previsualizar"
                lbl.font = UIFont.systemFont(ofSize: 15, weight: .medium)
                lbl.textColor = .systemGray
                lbl.textAlignment = .center
                lbl.tag = tagMensaje
                lbl.translatesAutoresizingMaskIntoConstraints = false
                
                view.addSubview(lbl)
                
                NSLayoutConstraint.activate([
                    lbl.centerXAnchor.constraint(equalTo: imgPreview.centerXAnchor),
                    lbl.centerYAnchor.constraint(equalTo: imgPreview.centerYAnchor),
                    lbl.leadingAnchor.constraint(equalTo: imgPreview.leadingAnchor, constant: 20),
                    lbl.trailingAnchor.constraint(equalTo: imgPreview.trailingAnchor, constant: -20)
                ])
            }
            imgPreview.backgroundColor = .systemGray6 
        } else {
            // Si ya hay una imagen cargada
            mensajeExistente?.removeFromSuperview()
            imgPreview.backgroundColor = .clear
        }
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

    // MARK: - Tabla de Vacunas
    func verificarListaVacia() {
        if listaVacunas.isEmpty {
            let labelMensaje = UILabel()
            labelMensaje.text = "No se registran vacunas aplicadas para esta mascota."
            labelMensaje.textColor = .systemGray
            labelMensaje.textAlignment = .center
            labelMensaje.font = UIFont.preferredFont(forTextStyle: .headline)
            labelMensaje.numberOfLines = 0
            
            self.tvvacunas.backgroundView = labelMensaje
            self.tvvacunas.separatorStyle = .none
        } else {
            self.tvvacunas.backgroundView = nil
            self.tvvacunas.separatorStyle = .singleLine
        }
    }

    func cargarCarnetVacunas(idMascota: Int) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        let url = "https://apiveterinaria-production-238b.up.railway.app/api/vacunas-aplicadas/mascota/\(idMascota)/carnet"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "Accept": "application/json"]
        
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [VacunaAplicada].self) { response in
                switch response.result {
                case .success(let vacunas):
                    self.listaVacunas = vacunas
                    DispatchQueue.main.async {
                        self.tvvacunas.reloadData()
                        self.verificarListaVacia()
                    }
                case .failure(let error):
                    print("Error al obtener el carnet: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.verificarListaVacia()
                    }
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detalles", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destino = segue.destination as? DetallesMascotaController
        destino?.id = idMascota
    }
}
