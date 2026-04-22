//
//  UsuarioInfoDTO.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 19/04/26.
//

import UIKit

nonisolated
struct UsuarioInfoDTO: Codable{
    
    let idUsuario: String
    let nombres: String
    let apellidos: String
    let dni: String
    let email: String
    let rol: String
    let activo: Bool
    let celular: String?
    let genero: String?
    let fotoUrl: String?
    
}
