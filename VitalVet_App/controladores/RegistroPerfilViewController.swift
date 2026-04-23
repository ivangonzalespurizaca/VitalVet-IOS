//
//  RegistroPerfilViewController.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 22/04/26.
//

import UIKit
import FirebaseAuth

class RegistroPerfilViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listaGeneros.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listaGeneros[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtGenero.text = listaGeneros[row]
        self.view.endEditing(true)
    }
    
    
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtDNI: UITextField!
    @IBOutlet weak var txtCelular: UITextField!
    @IBOutlet weak var txtGenero: UITextField!
    @IBOutlet weak var pvGenero: UIPickerView!
    
    
    let enumService = EnumService()
    let authService = AuthService()
    var listaGeneros: [String] = []
    
    

    var emailRecibido: String?
    var passwordRecibido: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pvGenero.delegate = self
        pvGenero.dataSource = self
        cargarGeneros()
    }
    
    @IBAction func btnFinalizarRegistro(_ sender: Any) {
        // Validar datos
        guard let datosExtraidos = validarCampos() else { return }
        
        crearUsuarioEnFirebase(datos: datosExtraidos)
    }

    // MARK: - Pasos del Registro (Funciones Pequeñas)

    private func crearUsuarioEnFirebase(datos: (email: String, pass: String, nombre: String, apellido: String, dni: String, cel: String, gen: String)) {
        
        Auth.auth().createUser(withEmail: datos.email, password: datos.pass) { authResult, error in
            if let error = error {
                self.mostrarAlerta(mensaje: "Error Firebase: \(error.localizedDescription)")
                return
            }
            
            // Obtener Token
            self.obtenerTokenYRegistrarEnAPI(authResult: authResult, datos: datos)
        }
    }

    private func obtenerTokenYRegistrarEnAPI(authResult: AuthDataResult?, datos: (email: String, pass: String, nombre: String, apellido: String, dni: String, cel: String, gen: String)) {
        
        authResult?.user.getIDToken { idToken, error in
            guard let token = idToken, error == nil else {
                self.mostrarAlerta(mensaje: "Error al generar token")
                return
            }
            
            // Preparar el DTO
            let nuevoUsuario = UsuarioRegisterDTO(
                idToken: token,
                dni: datos.dni,
                nombres: datos.nombre,
                apellidos: datos.apellido,
                celular: datos.cel,
                genero: datos.gen
            )
            
            // Paso 3: Railway
            self.enviarARailway(dto: nuevoUsuario)
        }
    }

    private func enviarARailway(dto: UsuarioRegisterDTO) {
        print("Paso 3: Registrando y Sincronizando...")
        
        // El servicio ahora hace todo: Registra, Sincroniza con Railway y Guarda en UserDefaults
        authService.registrarYPersistir(datos: dto) { resultado in
            DispatchQueue.main.async {
                switch resultado {
                case .success(let usuario):
                    print("Todo listo: \(usuario.nombres) guardado en sesión.")
                    
                    // Mostramos alerta de éxito antes de navegar
                    let alerta = UIAlertController(title: "VitalVet", message: "¡Cuenta creada con éxito!", preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "Entrar", style: .default) { _ in
                        self.irAlHomeCliente()
                    })
                    self.present(alerta, animated: true)
                    
                case .failure(let error):
                    self.mostrarAlerta(mensaje: error.localizedDescription)
                }
            }
        }
    }
    
    
    func cargarGeneros(){
        enumService.obtenerGeneros { [weak self] generos in
            if let generosObtenidos = generos {
                self?.listaGeneros = generosObtenidos
                DispatchQueue.main.async {
                    self?.pvGenero.reloadAllComponents()
                }
            }
        }
    }
    
    private func mostrarAlerta(mensaje: String) {
        let alerta = UIAlertController(title: "VitalVet", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alerta, animated: true)
    }
    
    private func validarCampos() -> (String, String, String, String, String, String, String)? {
        guard let email = emailRecibido, let pass = passwordRecibido,
              let nom = txtNombre.text, !nom.isEmpty,
              let ape = txtApellido.text, !ape.isEmpty,
              let dni = txtDNI.text, !dni.isEmpty,
              let cel = txtCelular.text, !cel.isEmpty,
              let gen = txtGenero.text, !gen.isEmpty else {
            self.mostrarAlerta(mensaje: "Completa todos los campos")
            return nil
        }
        return (email, pass, nom, ape, dni, cel, gen)
    }
    
    private func irAlHomeCliente() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let homeVC = storyboard.instantiateViewController(withIdentifier: "TabBarCliente") as? UITabBarController {
                homeVC.modalPresentationStyle = .fullScreen
                homeVC.modalTransitionStyle = .crossDissolve
                self.present(homeVC, animated: true)
            }
        }

}
