import UIKit

class DetallesConsultaVeterinario: UIViewControllerProfile {

    // MARK: - Outlets
    
    // Cabecera e Información General
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblnombreVeterinario: UILabel!
    
    // Signos Vitales
    @IBOutlet weak var lblPeso: UILabel!
    @IBOutlet weak var lblTemperaturacons: UILabel!
    
    // Contenedores Estilizados (Cards)
    @IBOutlet weak var viewCardTratamiento: UIStackView!
    @IBOutlet weak var viewCardDiagnostico: UIStackView!
    
    // Contenido de las Cards
    @IBOutlet weak var lblDiagnostico: UILabel!
    @IBOutlet weak var lblTituloPlan: UILabel!  // Ejemplo: "💉 VACUNACIÓN"
    @IBOutlet weak var lblDetallePlan: UILabel! // Los ítems detallados
    
    // MARK: - Propiedades
    var consulta: ConsultaDTO?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cambiarTitulo(nuevoTexto: "Detalle Consulta")
        // 1. Aplicamos estilos visuales primero
        configurarEstilosTipograficos()
        configurarEstilosCards()
        
        // 2. Cargamos la información
        cargarDatos()
    }

    // MARK: - Configuración Visual
    
    private func configurarEstilosCards() {
        // Estilo para el cuadro de Diagnóstico (Blanco estándar)
        let grisBorde = UIColor.systemGray5.cgColor
        estilizarCard(viewCardDiagnostico, colorFondo: .white, colorBorde: grisBorde)
        
        // Nota: La Card de Tratamiento se estiliza dinámicamente en cargarDatos()
        // dependiendo de si es vacuna, medicamento o recomendación.
    }
    
    private func estilizarCard(_ vista: UIStackView, colorFondo: UIColor, colorBorde: CGColor) {
        vista.backgroundColor = colorFondo
        vista.layer.cornerRadius = 15
        vista.layer.borderWidth = 1.2
        vista.layer.borderColor = colorBorde
        
        // Sombra suave para efecto "flotante"
        vista.layer.shadowColor = UIColor.black.cgColor
        vista.layer.shadowOffset = CGSize(width: 0, height: 3)
        vista.layer.shadowRadius = 5
        vista.layer.shadowOpacity = 0.08
        vista.layer.masksToBounds = false
        
        // Padding interno (Margen) para que el texto no toque los bordes
        vista.isLayoutMarginsRelativeArrangement = true
        vista.layoutMargins = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
    }

    private func configurarEstilosTipograficos() {
        let colorDato = UIColor.black
        
        // Nombre Mascota Destacado
        lblNombre.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        lblNombre.textColor = colorDato
        
        lblFecha.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lblFecha.textColor = .systemGray
        
        // Signos Vitales
        [lblPeso, lblTemperaturacons].forEach {
            $0?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            $0?.textColor = colorDato
        }
        
        // Configuración de multilínea para textos largos
        [lblDiagnostico, lblDetallePlan].forEach {
            $0?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            $0?.textColor = colorDato
            $0?.numberOfLines = 0
            $0?.lineBreakMode = .byWordWrapping
        }
        
        lblTituloPlan.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    }

    // MARK: - Lógica de Datos
    
    func cargarDatos() {
        guard let c = consulta else { return }

        // 1. Asignación de datos básicos
        lblNombre.text = c.nombreMascota
        lblFecha.text = c.fechaConsulta
        lblnombreVeterinario.text = "Vet. \(c.nombreVeterinario)"
        
        // Formateo de números
        lblPeso.text = String(format: "%.1f kg", c.pesoActual)
        lblTemperaturacons.text = String(format: "%.1f °C", c.temperatura)
        
        lblDiagnostico.text = c.diagnostico
        
        // 2. Lógica Dinámica para Vacunas vs Tratamientos
        var cuerpoTexto = ""
        
        if !c.vacunas.isEmpty {
            // Estilo Card Vacunación (Verde suave)
            lblTituloPlan.text = "VACUNACIÓN"
            lblTituloPlan.textColor = UIColor(red: 0.1, green: 0.5, blue: 0.2, alpha: 1.0)
            
            let verdeMuySuave = UIColor(red: 0.96, green: 1.0, blue: 0.96, alpha: 1.0)
            let verdeBorde = UIColor(red: 0.8, green: 0.95, blue: 0.8, alpha: 1.0).cgColor
            estilizarCard(viewCardTratamiento, colorFondo: verdeMuySuave, colorBorde: verdeBorde)
            
            for v in c.vacunas {
                cuerpoTexto += "• \(v.nombreVacuna)\n  Stado: \(v.estado.capitalized)\n\n"
            }
            
        } else if !c.tratamientos.isEmpty {
            // Estilo Card Tratamiento (Azul suave)
            lblTituloPlan.text = "TRATAMIENTO MEDICADO"
            lblTituloPlan.textColor = .systemBlue
            
            let azulMuySuave = UIColor(red: 0.96, green: 0.98, blue: 1.0, alpha: 1.0)
            let azulBorde = UIColor(red: 0.85, green: 0.9, blue: 1.0, alpha: 1.0).cgColor
            estilizarCard(viewCardTratamiento, colorFondo: azulMuySuave, colorBorde: azulBorde)
            
            for t in c.tratamientos {
                cuerpoTexto += "• \(t.nombreMedicamento)\n  Dosis: \(t.dosis) (\(t.frecuencia))\n\n"
            }
            
        } else {
            // Estilo Card Recomendaciones (Gris neutro)
            lblTituloPlan.text = "RECOMENDACIONES"
            lblTituloPlan.textColor = .darkGray
            
            let grisMuySuave = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
            let grisBorde = UIColor.systemGray5.cgColor
            estilizarCard(viewCardTratamiento, colorFondo: grisMuySuave, colorBorde: grisBorde)
            
            cuerpoTexto = c.recomendaciones ?? "No se registraron observaciones adicionales."
        }
        
        // Limpieza de espacios y asignación final
        lblDetallePlan.text = cuerpoTexto.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
