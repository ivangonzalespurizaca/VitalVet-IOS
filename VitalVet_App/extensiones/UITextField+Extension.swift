import UIKit

extension UITextField {
    
    func configurarEstiloVitalVet(icono: String, placeholder: String) {
        // 1. Placeholder
        self.placeholder = placeholder
        
        // 2. Icono en el lado izquierdo
        let viewContenedora = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        let imagenIcono = UIImageView(frame: CGRect(x: 12, y: 0, width: 20, height: 20))
        
        imagenIcono.image = UIImage(systemName: icono)
        imagenIcono.contentMode = .scaleAspectFit
        imagenIcono.tintColor = .systemGray
        
        viewContenedora.addSubview(imagenIcono)
        self.leftView = viewContenedora
        self.leftViewMode = .always
        
        // 3. Estilo visual: Fondo y Bordes
        self.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.borderStyle = .none
        
        // 4. Margen derecho (para que el texto no choque con el borde)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UITextView {
    
    func configurarEstiloVitalVet(placeholder: String) {
        // 1. Color de fondo y bordes redondeados
        self.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        self.layer.cornerRadius = 12
        
        // 2. Borde sutil para dar profundidad
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.systemGray5.cgColor
        
        // 3. Margen interno (Padding)
        // Esto evita que el texto choque con los bordes del cuadro
        self.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        
        // 4. Estilo de fuente
        self.font = .systemFont(ofSize: 15)
        self.textColor = .darkGray
        
        // 5. Quitar indicadores de scroll si es necesario
        self.showsVerticalScrollIndicator = false
    }
}
