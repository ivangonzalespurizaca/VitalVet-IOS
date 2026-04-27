//
//  DetallesConsultaVeterinario.swift
//  VitalVet_App
//
//  Created by XCODE on 27/04/26.
//

import UIKit


class DetallesConsultaVeterinario: UIViewController {

    // Cabecera
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblnombreVeterinario: UILabel!
    
    // Tarjeta Signos
    @IBOutlet weak var viewSignos: UIView!
    @IBOutlet weak var lblPeso: UILabel!
    @IBOutlet weak var lblTemperaturacons: UILabel!
    
    // Diagnóstico
    @IBOutlet weak var viewPlanContenedor: UIView! // El cuadro blanco del medio
    @IBOutlet weak var lblDiagnostico: UILabel!
    
    // Tratamiento / Vacunas (La parte de abajo)
    @IBOutlet weak var viewtratamiento: UIView!
    @IBOutlet weak var lblTituloPlan: UILabel! // El título que dice "Tratamiento" o "Vacuna"
    @IBOutlet weak var lblDetallePlan: UILabel! // El label con el texto largo final
    
    var consulta: ConsultaDTO?

    override func viewDidLoad() {
        super.viewDidLoad()
        aplicarDiseno()
        cargarDatos()
    }

    func aplicarDiseno() {
        // Redondeamos las tarjetas
        [viewSignos, viewPlanContenedor, viewtratamiento].forEach { view in
            view?.layer.cornerRadius = 12
            view?.clipsToBounds = true
        }
        
        viewSignos.backgroundColor = .systemGray6
        viewPlanContenedor.layer.borderWidth = 0.5
        viewPlanContenedor.layer.borderColor = UIColor.lightGray.cgColor
    }

    func cargarDatos() {
        guard let c = consulta else { return }

        // 1. Datos básicos
        lblNombre.text = c.nombreMascota
        lblFecha.text = c.fechaConsulta
        lblnombreVeterinario.text = c.nombreVeterinario
        lblPeso.text = "\(c.pesoActual) kg"
        lblTemperaturacons.text = "\(c.temperatura) °C"
        lblDiagnostico.text = c.diagnostico
        
        // 2. Lógica de Vacunas vs Tratamientos
        var cuerpoTexto = ""
        
        if !c.vacunas.isEmpty {
            lblTituloPlan.text = "💉 VACUNACIÓN"
            viewtratamiento.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
            for v in c.vacunas {
                cuerpoTexto += "• \(v.nombreVacuna)\n  Status: \(v.estado)\n\n"
            }
        } else if !c.tratamientos.isEmpty {
            lblTituloPlan.text = "TRATAMIENTO"
            viewtratamiento.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            for t in c.tratamientos {
                cuerpoTexto += "• \(t.nombreMedicamento)\n  Dosis: \(t.dosis) (\(t.frecuencia))\n\n"
            }
        } else {
            lblTituloPlan.text = " RECOMENDACIONES"
            cuerpoTexto = c.recomendaciones ?? "Sin observaciones."
        }
        
        lblDetallePlan.text = cuerpoTexto.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
