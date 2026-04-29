//
//  ListadoVeterinariosViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 20/04/26.
//

import UIKit
import Kingfisher

class ListadoVeterinariosViewController: UIViewControllerProfile, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaVets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1. Dequeue
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CeldaVeterinarios
        
        // 2. Obtener data
        let vet = listaVets[indexPath.row]
        
        // 3. Pasar la responsabilidad a la celda
        cell.configurar(con: vet)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueDatosVet", sender: nil)
    }
    
    @IBOutlet weak var tvVeterinarios: UITableView!
    
    
    var listaVets: [VeterinarioInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        cambiarTitulo(nuevoTexto: "Gestionar Veterinarios")
        self.imgPerfil.isHidden = true
        tvVeterinarios.dataSource = self
        tvVeterinarios.delegate = self
        tvVeterinarios.rowHeight = 125
        tvVeterinarios.separatorStyle = .none
        cargarVeterinarios()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarVeterinarios()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1. Verificamos que sea el Segue correcto (el nombre que pusiste en el Storyboard)
        if segue.identifier == "segueDatosVet",
           let pantallaDestino = segue.destination as? EditarVeterinarioViewController,
           let filaSeleccionada = tvVeterinarios.indexPathForSelectedRow?.row {
            
            // 2. Obtenemos el veterinario de la lista usando el índice de la celda tocada
            let veterinario = listaVets[filaSeleccionada]
            
            // 3. Pasamos el objeto completo a la variable de la siguiente pantalla
            pantallaDestino.veterinarioSeleccionado = veterinario
        }
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



        @IBAction func btnRegistrar(_ sender: Any) {
            performSegue(withIdentifier: "segueNuevoVet", sender: nil)
        }

}
