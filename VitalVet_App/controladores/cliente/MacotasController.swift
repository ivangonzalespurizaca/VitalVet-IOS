import UIKit
import Alamofire

class MacotasController: UIViewControllerProfile, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var listaMascotas: [Mascota] = []
    @IBOutlet weak var cvMascotas: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cvMascotas.dataSource = self
        cvMascotas.delegate = self
        cambiarTitulo(nuevoTexto: "Mis Mascotas")
        cargarMascotasDeAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarMascotasDeAPI()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listaMascotas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvMascotas.dequeueReusableCell(withReuseIdentifier: "celdaMascotas", for: indexPath) as! celdaCollectionMascota
        
        let mascota = listaMascotas[indexPath.item]
        cell.txtnombreMascota.text = mascota.nombreMascota
        cell.txtespecie.text = mascota.especie
        cell.txtRaza.text = mascota.raza
        
        
        
        
        var urlString = mascota.fotoUrl
        if urlString.hasPrefix("http://") {
            urlString = urlString.replacingOccurrences(of: "http://", with: "https://")
        }
        let urlConCache = urlString + "?v=\(Date().timeIntervalSince1970)"

        if let url = URL(string: urlConCache) {
            cargarImagen(url: url, en: cell.imgmascota)
        }

        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mascotaSeleccionada = listaMascotas[indexPath.item]
        performSegue(withIdentifier: "irActualizarFoto", sender: mascotaSeleccionada)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irActualizarFoto",
           let destino = segue.destination as? ActualizarFotoController,
           let mascota = sender as? Mascota {
            destino.idMascota = mascota.idMascota
        }
    }
    
    
    func cargarImagen(url: URL, en imageView: UIImageView) {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    UIView.transition(with: imageView, duration: 0.3, options: .transitionCrossDissolve) {
                        imageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }

    func cargarMascotasDeAPI() {
        guard let token = UserDefaults.standard.string(forKey: "userToken"),
              let userId = UserDefaults.standard.string(forKey: "userId") else { return }

        let url = "https://apiveterinaria-production-238b.up.railway.app/api/mascotas/cliente/\(userId)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [Mascota].self) { response in
                switch response.result {
                case .success(let mascotasRecibidas):
                    self.listaMascotas = mascotasRecibidas
                    self.cvMascotas.reloadData()
                case .failure(let error):
                    print("Error al obtener las mascotas: \(error.localizedDescription)")
                }
            }
    }
    
    @IBAction func btnNuevo(_ sender: UIButton) {
        performSegue(withIdentifier: "nuevoMascota", sender: nil)
    }
    
    
    @IBAction func btnVacunas(_ sender: UIButton) {
        performSegue(withIdentifier: "vacunas", sender: nil)
    }
}
