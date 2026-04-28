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
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchConsultas()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configurarDisenoColumnas()
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
        
        // Llenado de datos
        cell.lblMascota.text = consulta.nombreMascota
        cell.lblFecha.text = consulta.fechaConsulta
        cell.txtdiagnostico.text = consulta.diagnostico
        cell.img.image = UIImage(named: "pets.png")
        cell.img.layer.cornerRadius = cell.img.frame.size.width / 2
        cell.img.clipsToBounds = true
        cell.img.contentMode = .scaleAspectFill
        cell.layer.masksToBounds = false
        
        // Estilo visual de la tarjeta
        cell.layer.cornerRadius = 12
        cell.backgroundColor = .systemGray6
        
        // Configuración de sombra
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 4
        cell.layer.shadowOpacity = 0.1
        cell.layer.masksToBounds = false
        
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
    
    
    // MARK: - Acciones
    @IBAction func btnRegistrar(_ sender: UIButton) {
        performSegue(withIdentifier: "nuevo", sender: nil)
    }
}
