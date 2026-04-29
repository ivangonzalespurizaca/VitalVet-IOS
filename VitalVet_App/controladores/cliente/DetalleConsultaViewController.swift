//
//  DetalleConsultaViewController.swift
//  VitalVet_App
//
//  Created by XCODE on 25/04/26.
//

import UIKit

class DetalleConsultaViewController: UIViewControllerProfile, UITableViewDataSource, UITableViewDelegate {
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
                cell.lblFechaAplicacion.text = "Fecha Aplicación: \(vacuna.fechaAplicacion)"
                cell.configurarFechaProgramada(fecha: vacuna.fechaProgramada)
                cell.lblNroDosis.text = "Nro. Dosis: \(vacuna.nroDosis)"
                cell.lblEstado.text = "Estado: \(vacuna.estado)"
                
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
        
        cambiarTitulo(nuevoTexto: "Detalles Consulta")
                
                // Mostrar los detalles de la consulta
                mostrarConsulta()
        
    }
    
    func mostrarConsulta() {
        // 🛡️ SEGURIDAD: Verificamos que la consulta exista Y que el primer label esté conectado
            guard let consultaSegura = self.consulta else {
                print("⚠️ Error: La variable consulta llegó nula")
                return
            }
            
            // Verificamos si los labels ya fueron creados por el sistema
            if isViewLoaded && lblDiagnostico != nil {
                lblDiagnostico.text = "Diagnóstico: \(consultaSegura.diagnostico)"
                lblFechaConsulta.text = "Fecha Consulta: \(consultaSegura.fechaConsulta)"
                lblPesoActual.text = "Peso: \(consultaSegura.pesoActual) kg"
                lblTemperatura.text = "Temperatura: \(consultaSegura.temperatura) °C"
                lblRecomendaciones.text = "Recomendaciones: \(consultaSegura.recomendaciones ?? "Sin recomendaciones")"
                lblVeterinario.text = "Veterinario: \(consultaSegura.nombreVeterinario)"
                
                // Actualizamos las listas locales
                self.tratamientos = consultaSegura.tratamientos
                self.vacunas = consultaSegura.vacunas
                
                // Recargamos tablas
                tvTratamientos.reloadData()
                tvVacunas.reloadData()
            }
        }


}
