//
//  LogDTO.swift
//  VitalVet_App
//
//  Created by XCODE on 27/04/26.
//

import Foundation


nonisolated
struct LogDTO: Codable {
    let idLog: Int
    let nombreUsuario: String? // Puede ser nulo según tu Service (SISTEMA)
    let rolUsuario: String?
    let tablaAfectada: String
    let accion: String
    let descripcion: String
    let fechaRegistro: String // Formato ISO8601 que envía LocalDateTime
}
