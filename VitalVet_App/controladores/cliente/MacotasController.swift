//
//  MacotasController.swift
//  VitalVet_App
//
//  Created by XCODE on 23/04/26.
//

import UIKit
import Alamofire

class MacotasController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    var listaMascotas:[Mascota]=[]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listaMascotas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = cvMascotas.dequeueReusableCell(withReuseIdentifier: "celdaMascotas", for: indexPath) as! celdaCollectionMascota
        
        // Obtenemos el objeto mascota de la posición actual
        let mascota = listaMascotas[indexPath.item]
        
        // Asignamos los textos
        cell.txtnombreMascota.text = mascota.nombreMascota
        cell.txtespecie.text = mascota.especie
        cell.txtRaza.text = mascota.raza
        
        // Para la imagen desde URL (usando una función básica de carga):
        if let url = URL(string: mascota.fotoUrl) {
            cargarImagen(url: url, en: cell.imgmascota)
        }
        
        
        cell.layer.cornerRadius = 10
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ancho = collectionView.frame.width - 40
        return CGSize(width: ancho, height: 200)
    }

    func cargarImagen(url: URL, en imageView: UIImageView) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            }
        }
    }
    

    @IBOutlet weak var cvMascotas: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        cvMascotas.dataSource = self
        cvMascotas.delegate = self
            
            // Luego llamas a tu función de Alamofire
        cargarMascotasDeAPI()

    }
    
  



    func cargarMascotasDeAPI() {
        let defaults = UserDefaults.standard
        
        guard let token = defaults.string(forKey: "userToken"),
                  let userId = defaults.string(forKey: "userId") else {
                return
            }

    
        let url = "https://apiveterinaria-production-238b.up.railway.app/api/mascotas/cliente/\(userId)"
        
        print("Consultando mascotas del cliente: \(userId)")

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
                    DispatchQueue.main.async {
                        self.cvMascotas.reloadData()
                    }
                    
                case .failure(let error):
                    // Si la API responde 404 es probable que el cliente no tenga mascotas aún
                    print("Error al obtener las mascotas: \(error.localizedDescription)")
                }
            }
    }
    
    


}
