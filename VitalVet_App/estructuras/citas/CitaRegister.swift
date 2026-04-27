//
//  CitaRegister.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 26/04/26.
//

import UIKit

nonisolated
struct CitaRegister: Codable {
    let idMascota: Int
    let idVeterinario: Int
    let fecha: String
    let hora: String
    let motivo: String
}
