import UIKit
import Alamofire

class ListadoConsultasViewController: UIViewControllerProfile, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var listaConsultas: [ConsultaDTO] = []
    
    
    let idVeterinario = UserDefaults.standard.string(forKey: "userId") ?? ""
    let token = UserDefaults.standard.string(forKey: "userToken") ?? ""

    override func viewDidLoad() {
        super.viewDidLoad()
        cambiarTitulo(nuevoTexto: "Mis Consultas")
        self.imgPerfil.isHidden = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchConsultas()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configurarDisenoColumnas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchConsultas()
    }

    // MARK: - Diseño de 2 Columnas (Layout)
    func configurarDisenoColumnas() {
        guard let cv = collectionView else { return }

        let layout = UICollectionViewFlowLayout()
        let espaciado: CGFloat = 12
        
        let anchoCV = cv.frame.width
        
        guard anchoCV > 0 else { return }
        
        let anchoCelda = (anchoCV - (espaciado * 3)) / 2
        
        layout.itemSize = CGSize(width: anchoCelda, height: 210)
        layout.minimumInteritemSpacing = espaciado
        layout.minimumLineSpacing = espaciado
        layout.sectionInset = UIEdgeInsets(top: espaciado, left: espaciado, bottom: espaciado, right: espaciado)
        
        cv.setCollectionViewLayout(layout, animated: false)
    }

    // MARK: - Consumo de API con Alamofire
    func fetchConsultas() {
        guard !idVeterinario.isEmpty, !token.isEmpty else {
            print("Error: Faltan credenciales (ID o Token)")
            return
        }
        
        let url = "https://apiveterinaria-production-238b.up.railway.app/api/consultas/veterinario/\(idVeterinario)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [ConsultaDTO].self) { response in
                switch response.result {
                case .success(let consultas):
                    self.listaConsultas = consultas
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    print("Error en API: \(error.localizedDescription)")
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Respuesta del servidor: \(utf8Text)")
                    }
                }
            }
    }

    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listaConsultas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celdaConsulta", for: indexPath) as? ConsultaCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let consulta = listaConsultas[indexPath.item]
        
        // Solo llamamos a la función de la celda y le pasamos los datos
        cell.configurar(
            mascota: consulta.nombreMascota,
            fecha: consulta.fechaConsulta,
            diagnostico: consulta.diagnostico,
            imagenNombre: "pets.png" // O el nombre de tu imagen
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let consultaSeleccionada = listaConsultas[indexPath.item]
        performSegue(withIdentifier: "verDetalle", sender: consultaSeleccionada)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verDetalle" {
            
            if let detalleVC = segue.destination as? DetallesConsultaVeterinario,
               let consulta = sender as? ConsultaDTO {
                detalleVC.consulta = consulta
            }
        }
    }
    
    @IBAction func btnRegistrar(_ sender: Any) {
        performSegue(withIdentifier: "nuevo", sender: nil)
    }
    
}
