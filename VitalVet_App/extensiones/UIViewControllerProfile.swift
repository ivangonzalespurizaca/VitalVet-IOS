import UIKit
import Kingfisher

class UIViewControllerProfile: UIViewController {
    
    let imgPerfil = UIImageView()
    let lblSaludo = UILabel()
    
    // Nueva variable para guardar un título personalizado
    private var tituloPersonalizado: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderBase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        actualizarDatosHeader()
    }
    
    private func setupHeaderBase() {
        let headerBackground = UIView()
        headerBackground.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 130)
        headerBackground.backgroundColor = .white
        
        // Una pequeña sombra para darle profundidad
        headerBackground.layer.shadowColor = UIColor.black.cgColor
        headerBackground.layer.shadowOffset = CGSize(width: 0, height: 2)
        headerBackground.layer.shadowOpacity = 0.05
        
        view.addSubview(headerBackground)
        
        // ... (Tu configuración de frames se mantiene igual)
        imgPerfil.frame = CGRect(x: view.frame.width - 70, y: 60, width: 50, height: 50)
        imgPerfil.layer.cornerRadius = 25
        imgPerfil.clipsToBounds = true
        imgPerfil.isUserInteractionEnabled = true
        imgPerfil.contentMode = .scaleAspectFill
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(irAEditarPerfil))
        imgPerfil.addGestureRecognizer(tap)
        
        lblSaludo.frame = CGRect(x: 0, y: 60, width: view.frame.width, height: 50)
        lblSaludo.textAlignment = .center
        lblSaludo.font = UIFont.boldSystemFont(ofSize: 18)
        
        view.addSubview(lblSaludo)
        view.addSubview(imgPerfil)
        
        view.bringSubviewToFront(imgPerfil)
        view.bringSubviewToFront(lblSaludo)
    }

    func actualizarDatosHeader() {
        let defaults = UserDefaults.standard
        
        // LÓGICA INTELIGENTE PARA EL TÍTULO:
        if let tituloFix = tituloPersonalizado {
            lblSaludo.text = tituloFix
        } else {
            let nombre = defaults.string(forKey: "userNombre") ?? "Usuario"
            lblSaludo.text = "¡Hola, \(nombre)!"
        }
        
        // --- Carga de imagen (Igual que antes) ---
        if var urlStr = defaults.string(forKey: "userFotoUrl") {
            if urlStr.hasPrefix("http://") {
                urlStr = urlStr.replacingOccurrences(of: "http://", with: "https://")
            }
            if let url = URL(string: urlStr) {
                imgPerfil.kf.setImage(with: url, placeholder: UIImage(systemName: "person.circle.fill"))
            }
        } else {
            imgPerfil.image = UIImage(systemName: "person.circle.fill")
        }
    }

    func cambiarTitulo(nuevoTexto: String) {
        self.tituloPersonalizado = nuevoTexto
        self.lblSaludo.text = nuevoTexto
    }
    
    @objc func irAEditarPerfil() {
        if let perfilVC = storyboard?.instantiateViewController(withIdentifier: "PerfilUsuarioViewController") {
            self.navigationController?.pushViewController(perfilVC, animated: true)
        }
    }
}
