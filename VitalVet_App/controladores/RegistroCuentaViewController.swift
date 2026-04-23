//
//  RegistroViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 22/04/26.
//

import UIKit

class RegistroCuentaViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtContrasenia: UITextField!
    @IBOutlet weak var txtRepContrasenia: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueRegistrarPerfil" {
            if let pantallaDestino = segue.destination as? RegistroPerfilViewController {
                
                pantallaDestino.emailRecibido = txtEmail.text
                pantallaDestino.passwordRecibido = txtContrasenia.text
            }
        }
    }
    
    
    @IBAction func btnSeguiente(_ sender: Any) {
        if txtContrasenia.text == txtRepContrasenia.text {
            performSegue(withIdentifier: "segueRegistrarPerfil", sender: self)
        } else {
            print("Las contraseñas no coinciden")
        }
    }
    

}
