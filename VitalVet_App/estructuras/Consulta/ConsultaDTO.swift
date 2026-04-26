//
//  ConsultaDTO.swift
//  VitalVet_App
//
//  Created by XCODE on 25/04/26.
//

import UIKit
import Foundation

// DTO para tratamiento
struct TratamientoDTO: Codable {
    let nombreMedicamento: String
    let dosis: String
    let frecuencia: String
    let duracionDias: Int? 
}

// DTO para vacuna
struct VacunaDTO: Codable {
    let idAplicacion: Int
    let nombreVacuna: String
    let descripcionVacuna: String
    let fechaAplicacion: String
    let fechaProgramada: String?
    let nroDosis: Int
    let estado: String
    let nombreVeterinario: String
    let observaciones: String
}

// DTO para consulta
struct ConsultaDTO: Codable {
    let idConsulta: Int
    let idCita: Int
    let nombreMascota: String
    let fechaConsulta: String
    let pesoActual: Double
    let temperatura: Double
    let diagnostico: String
    let recomendaciones: String?
    let nombreVeterinario: String
    let tratamientos: [TratamientoDTO]
    let vacunas: [VacunaDTO]
}
