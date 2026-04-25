//
//  HorarioRegister.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 24/04/26.
//

import UIKit

nonisolated
struct HorarioRegister: Codable {
    let idVeterinario: Int
    let diaSemana: String
    let horaInicio: String
    let horaFin: String
}
