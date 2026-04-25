//
//  HorarioInfo.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 24/04/26.
//

import UIKit

nonisolated
struct HorarioInfo: Codable {
    let idHorario: Int
    let nombreVeterinario: String
    let diaSemana: String
    let horaInicio: String
    let horaFin: String
    let activo: Bool
}
