//
//  VeterinarioInfo.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 23/04/26.
//

import UIKit

nonisolated
struct VeterinarioInfo: Codable {
    let idUsuario: String?
    let idVeterinario: Int?
    let nombres: String
    let apellidos: String
    let email: String
    let fotoUrl: String?
    let activo: Bool?
    let dni: String
    let numColegiatura: String
    let especialidad: String
}
