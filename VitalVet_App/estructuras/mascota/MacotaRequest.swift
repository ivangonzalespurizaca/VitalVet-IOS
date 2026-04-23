//
//  MacotaRequest.swift
//  VitalVet_App
//
//  Created by XCODE on 23/04/26.
//

import UIKit

nonisolated
struct MascotaRequest :Codable{
    let idCliente: String
    let nombreMascota: String
    let especie: String
    let raza: String
    let sexo: String
    let fechaNacimiento: String
    let pesoActual: Double
}
