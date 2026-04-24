//
//  ListadoVeterinariosViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 20/04/26.
//

import UIKit
import Kingfisher

class ListadoVeterinariosViewController: UIViewControllerProfile, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tvVeterinarios: UITableView!
        var listaVets: [VeterinarioInfo] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            cambiarTitulo(nuevoTexto: "Gestionar Veterinarios")
            
            tvVeterinarios.dataSource = self
            tvVeterinarios.delegate = self
            
            cargarVeterinarios()
        }
        
        func cargarVeterinarios() {
            guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
            
            VeterinarioService.shared.listarVeterinarios(token: token) { [weak self] resultado in
                switch resultado {
                case .success(let vets):
                    self?.listaVets = vets
                    self?.tvVeterinarios.reloadData()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return listaVets.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CeldaVeterinarios
            let vet = listaVets[indexPath.row]
            
            cell.lblNombres.text = "\(vet.nombres) \(vet.apellidos)"
            
            cell.lblEspecialidad.text = vet.especialidad.replacingOccurrences(of: "_", with: " ").capitalized
            cell.lblColegiatura.text = "Colegiatura: \(vet.numColegiatura)"
            
            // Foto con Kingfisher
            let url = URL(string: vet.fotoUrl ?? "")
            cell.imgVet.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle.fill"))
            
            return cell
        }
        
        // Altura de la celda (ajústalo según tu diseño)
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }

        @IBAction func btnRegistrar(_ sender: Any) {
            performSegue(withIdentifier: "segueNuevoVet", sender: nil)
        }

}
