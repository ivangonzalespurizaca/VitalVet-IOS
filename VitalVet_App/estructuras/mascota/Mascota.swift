//
//  Mascota.swift
//  VitalVet_App
//
//  Created by XCODE on 23/04/26.
//

import UIKit

nonisolated
struct Mascota: Codable {
    let idMascota: Int
    let nombreMascota: String
    let especie: String
    let raza: String
    let sexo: String
    let nombreDuenio: String
    let dniDuenio: String
    let edad: Int
    let pesoActual: Double
    let fotoUrl: String
}
