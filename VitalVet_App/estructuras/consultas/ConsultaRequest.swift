//
//  ConsultaRequest.swift
//  VitalVet_App
//
//  Created by XCODE on 26/04/26.
//

import UIKit

nonisolated
struct ConsultaRequest: Codable {
    let idCita: Int
    let pesoActual: Double
    let temperatura: Double
    let diagnostico: String
    let recomendaciones: String
    let tratamientos: [TratamientoRequest]
    let vacunas: [VacunaRequest]
}

struct TratamientoRequest: Codable {
    let nombreMedicamento: String
    let dosis: String
    let frecuencia: String
    let duracionDias: Int
}

struct VacunaRequest: Codable {
    let idVacuna: Int
    let nroDosis: Int
    let observaciones: String
}

nonisolated
struct VacunaDisponible: Codable {
    let idVacuna: Int
    let nombreVacuna: String
    let descripcion: String
    let activo: Bool
}
