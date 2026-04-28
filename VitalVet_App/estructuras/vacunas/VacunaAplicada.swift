//
//  VacunaAplicada.swift
//  VitalVet_App
//
//  Created by XCODE on 23/04/26.
//

import UIKit

nonisolated
struct VacunaAplicada: Codable {
    let idAplicacion: Int?
    let nombreVacuna: String?
    let descripcionVacuna: String?
    let fechaAplicacion: String? // Ahora acepta el 'null' que viene del JSON
    let fechaProgramada: String?
    let nroDosis: Int?
    let estado: String?
    let nombreVeterinario: String?
    let observaciones: String?
}
