//
//  CitaInfo.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 26/04/26.
//

import UIKit

nonisolated
struct CitaInfo: Codable {
    let idCita: Int
    let nombreMascota: String
    let fotoMascotaUrl: String?
    let nombreCliente: String
    let celularCliente: String
    let nombreVeterinario: String
    let especialidadVeterinario: String
    let fecha: String
    let hora: String
    let estado: String
    let motivo: String
}
