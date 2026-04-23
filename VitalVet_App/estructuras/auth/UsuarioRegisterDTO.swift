//
//  UsuarioRegisterDTO.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 19/04/26.
//

import UIKit

nonisolated
struct UsuarioRegisterDTO: Codable {
    let idToken: String
    let dni: String
    let nombres: String
    let apellidos: String
    let celular: String
    let genero: String // Mapeado de TipoGenero
}
