//
//  ProgramarVacunaRequest.swift
//  VitalVet_App
//
//  Created by XCODE on 26/04/26.
//

import UIKit
nonisolated
struct ProgramarVacunaRequest: Codable {
    let idVacuna: Int
    let nroDosis: Int
    let fechaProgramada: String
    let observaciones: String
}
