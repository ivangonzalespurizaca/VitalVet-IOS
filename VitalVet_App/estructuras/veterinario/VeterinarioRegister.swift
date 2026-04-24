//
//  VeterinarioRegister.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 23/04/26.
//

import UIKit

nonisolated
struct VeterinarioRegister: Codable {
    let idUsuario: String
    let nombres: String
    let apellidos: String
    let email: String
    let dni: String
    let celular: String?
    let genero: String
    let numColegiatura: String
    let especialidad: String
}
