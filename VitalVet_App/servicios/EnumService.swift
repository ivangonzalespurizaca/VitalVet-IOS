//
//  EnunService.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 22/04/26.
//

import UIKit
import Alamofire

class EnumService {
    
    static let shared = EnumService()
    
    private let baseURL = "https://apiveterinaria-production-238b.up.railway.app/api/public/enums"

    func obtenerGeneros(completion: @escaping ([String]?) -> Void) {
        let url = "\(baseURL)/generos"
        
        AF.request(url).responseDecodable(of: [String].self) { response in
            switch response.result {
            case .success(let generos):
                completion(generos)
            case .failure(let error):
                print("Error obteniendo géneros: \(error)")
                completion(nil)
            }
        }
    }
    
    func obtenerEspecialidades(completion: @escaping ([String]?) -> Void) {
        let url = "\(baseURL)/especialidades"
        
        AF.request(url).responseDecodable(of: [String].self) { response in
            switch response.result {
            case .success(let especialidades):
                completion(especialidades)
            case .failure(let error):
                print("Error obteniendo especialidades: \(error)")
                completion(nil)
            }
        }
    }
    
    func obtenerDiasSemana(completion: @escaping ([String]?) -> Void) {
        let url = "\(baseURL)/dias-semana"
        
        AF.request(url).responseDecodable(of: [String].self) { response in
            if let dias = response.value {
                completion(dias)
            } else {
                completion(nil)
            }
        }
    }
    
    func obtenerEspecies(completion: @escaping ([String]?) -> Void) {
        let url = "\(baseURL)/especies"
        
        AF.request(url).responseDecodable(of: [String].self) { response in
            if let especies = response.value {
                completion(especies)
            } else {
                completion(nil)
            }
        }
    }
    
    func obtenerSexoMascota(completion: @escaping ([String]?) -> Void) {
        let url = "\(baseURL)/sexo-mascota"
        
        AF.request(url).responseDecodable(of: [String].self) { response in
            if let sexos = response.value {
                completion(sexos)
            } else {
                completion(nil)
            }
        }
    }
    
    func obtenerRoles(completion: @escaping ([String]?) -> Void) {
        let url = "\(baseURL)/rol"
        
        AF.request(url).responseDecodable(of: [String].self) { response in
            if let roles = response.value {
                completion(roles)
            } else {
                completion(nil)
            }
        }
    }
    
    func obtenerEstadosCita(completion: @escaping ([String]?) -> Void) {
        let url = "\(baseURL)/estado-cita"
        
        AF.request(url).responseDecodable(of: [String].self) { response in
            if let estadosCita = response.value {
                completion(estadosCita)
            } else {
                completion(nil)
            }
        }
    }
    
    func obtenerEstadosVacuna(completion: @escaping ([String]?) -> Void) {
        let url = "\(baseURL)/estado-vacuna"
        
        AF.request(url).responseDecodable(of: [String].self) { response in
            if let estadosVacuna = response.value {
                completion(estadosVacuna)
            } else {
                completion(nil)
            }
        }
    }
    
    
    
}
