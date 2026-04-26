//
//  DetalleConsultaViewController.swift
//  VitalVet_App
//
//  Created by XCODE on 25/04/26.
//

import UIKit

class DetalleConsultaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tvTratamientos {
                    return tratamientos.count
                } else {
                    return vacunas.count
                }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tvTratamientos {
                let cell = tableView.dequeueReusableCell(withIdentifier: "celdaTratamiento", for: indexPath) as! celdaTratamiento
                let tratamiento = tratamientos[indexPath.row]

            cell.lblMedicamemto.text = "Medicamento: \(tratamiento.nombreMedicamento)"
                cell.lblDosis.text = "Dosis: \(tratamiento.dosis)"
                cell.lblFrecuencia.text = "Frecuencia: \(tratamiento.frecuencia)"
                cell.lblDuracionDias.text = tratamiento.duracionDias != nil ? "Duración: \(tratamiento.duracionDias!) días" : "Duración: N/A"
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "celdaVacuna", for: indexPath) as! celdaVacuna
                let vacuna = vacunas[indexPath.row]

                cell.lblVacuna.text = "Vacuna: \(vacuna.nombreVacuna)"
                cell.lblDescripcion.text = "Descripcion: \(vacuna.descripcionVacuna)"
                cell.lblFechaAplicacion.text = "Fecha Aplicación: \(vacuna.fechaAplicacion)"
               cell.configurarFechaProgramada(fecha: vacuna.fechaProgramada)
                cell.lblNroDosis.text = "Nro. Dosis: \(vacuna.nroDosis)"
                cell.lblEstado.text = "Estado: \(vacuna.estado)"
                cell.lblVeterinario.text = "Veterinario: \(vacuna.nombreVeterinario)"
                cell.lblObservaciones.text = "Observaciones: \(vacuna.observaciones)"
                
                return cell
            }
    }
    
    
    @IBOutlet weak var lblDiagnostico: UILabel!
    
    @IBOutlet weak var lblFechaConsulta: UILabel!
    
    @IBOutlet weak var lblPesoActual: UILabel!
    
    @IBOutlet weak var lblTemperatura: UILabel!
    
    @IBOutlet weak var lblRecomendaciones: UILabel!
    
    @IBOutlet weak var lblVeterinario: UILabel!
    
    @IBOutlet weak var tvTratamientos: UITableView!
    
    @IBOutlet weak var tvVacunas: UITableView!
    
    var consulta: ConsultaDTO!
        
        var tratamientos: [TratamientoDTO] = []
        var vacunas: [VacunaDTO] = []
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configuración de las tablas
                tvTratamientos.dataSource = self
                tvTratamientos.delegate = self
                tvVacunas.dataSource = self
                tvVacunas.delegate = self
        
        tvTratamientos.rowHeight = 130
        tvVacunas.rowHeight = 180
                
                // Mostrar los detalles de la consulta
                mostrarConsulta()
        
    }
    
    func mostrarConsulta() {
        lblDiagnostico.text = "Diagnóstico: \(consulta.diagnostico)"
        lblFechaConsulta.text = "Fecha Consulta: \(consulta.fechaConsulta)"
            lblPesoActual.text = "Peso: \(consulta.pesoActual) kg"
            lblTemperatura.text = "Temperatura: \(consulta.temperatura) °C"
            lblRecomendaciones.text = "Recomendaciones: \(consulta.recomendaciones ?? "Sin recomendaciones")"
        lblVeterinario.text = "Veterinario: \(consulta.nombreVeterinario)"
            
            // Asignamos los tratamientos y vacunas
            tratamientos = consulta.tratamientos
            vacunas = consulta.vacunas
            
            tvTratamientos.reloadData()
            tvVacunas.reloadData()
        }


}
