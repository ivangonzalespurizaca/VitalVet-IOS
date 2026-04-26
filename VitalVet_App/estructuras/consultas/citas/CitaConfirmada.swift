//
//  CitaConfirmada.swift
//  VitalVet_App
//
//  Created by XCODE on 26/04/26.
//

import UIKit

nonisolated
struct CitaConfirmada: Codable {
    let idCita: Int
    let nombreMascota: String
    let fotoMascotaUrl: String
    let nombreCliente: String
    let celularCliente: String
    let fecha: String
    let hora: String
    let motivo: String
}
