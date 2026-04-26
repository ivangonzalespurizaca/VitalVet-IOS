//
//  VacunaElement.swift
//  VitalVet_App
//
//  Created by XCODE on 26/04/26.
//

import UIKit

nonisolated
struct VacunaElement: Codable {
    let idAplicacion: Int
    let nombreVacuna: String
    let descripcionVacuna: String
    let fechaAplicacion: String
    let nroDosis: Int
    let estado: String
    let nombreVeterinario: String
    let observaciones: String
}
