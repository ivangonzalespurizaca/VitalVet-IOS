//
//  UsuarioUpdateDTO.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 19/04/26.
//

import UIKit

nonisolated
struct UsuarioUpdateDTO: Codable {
    let nombres: String
    let apellidos: String
    let celular: String
    let genero: String
}

nonisolated
struct FotoResponse: Codable {
    let fotoUrl: String
}
