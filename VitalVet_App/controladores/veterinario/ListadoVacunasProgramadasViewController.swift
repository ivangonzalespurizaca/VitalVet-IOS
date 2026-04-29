import UIKit
import Alamofire


class ListadoVacunasProgramadasViewController: UIViewControllerProfile, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var vistaamostrar: UIView!
    @IBOutlet weak var txtdni: UITextField!
    @IBOutlet weak var tvmascotas: UITableView!
    
    var listaMascotas: [Mascota] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cambiarTitulo(nuevoTexto: "Gestión de Vacunación")
        
        vistaamostrar.isHidden = true
        tvmascotas.dataSource = self
        tvmascotas.delegate = self
        tvmascotas.rowHeight = 120
    }
    
    @IBAction func btnBuscarDni(_ sender: UIButton) {
        guard let dni = txtdni.text, !dni.isEmpty else { return }
        buscarMascotasAlamofire(dni: dni)
    }
    
    func buscarMascotasAlamofire(dni: String) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        let url = "https://apiveterinaria-production-238b.up.railway.app/api/mascotas/admin/buscar-por-dni"
        let parameters: [String: String] = ["dni": dni]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)", "Accept": "application/json"]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: [Mascota].self) { response in
                switch response.result {
                case .success(let mascotas):
                    self.listaMascotas = mascotas
                    self.tvmascotas.reloadData()
                    self.vistaamostrar.isHidden = mascotas.isEmpty
                case .failure(let error):
                    print("Error Alamofire: \(error.localizedDescription)")
                    self.vistaamostrar.isHidden = true
                }
            }
    }
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaMascotas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaxdni", for: indexPath) as! celdaMascotaxdni
        let mascota = listaMascotas[indexPath.row]
        
        cell.configurarDatos(con: mascota)

        // CONFIGURAR DOBLE TAP
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delaysTouchesBegan = true
        cell.addGestureRecognizer(doubleTap)
        
        return cell
    }

    // ACCIÓN DOBLE TAP
    @objc func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: tvmascotas)
        if let indexPath = tvmascotas.indexPathForRow(at: touchPoint) {
            let idString = "\(listaMascotas[indexPath.row].idMascota)"
            performSegue(withIdentifier: "cambiarestado", sender: idString)
        }
    }
    
    // ACCIÓN TAP SIMPLE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idString = "\(listaMascotas[indexPath.row].idMascota)"
        performSegue(withIdentifier: "programacion", sender: idString)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let idRecibido = sender as? String, let idInt = Int(idRecibido) else { return }
        
        if segue.identifier == "programacion" {
            let pantalla2 = segue.destination as! ProgramarcitaController
            pantalla2.id = idInt
        }
        else if segue.identifier == "cambiarestado" {
            let detalleVC = segue.destination as! CambiarEstadoController
            detalleVC.idMascota = idInt
        }
    }
}
