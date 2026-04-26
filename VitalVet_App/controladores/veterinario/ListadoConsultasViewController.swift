//
//  ListadoConsultasViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 20/04/26.
//

import UIKit

class ListadoConsultasViewController: UIViewControllerProfile {

    override func viewDidLoad() {
        super.viewDidLoad()
        cambiarTitulo(nuevoTexto: "Gestionar Consultas")
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnRegistrar(_ sender: UIButton) {
            performSegue(withIdentifier: "nuevo", sender: nil)
    }
    
    
    

}
