//
//  HorarioService.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 24/04/26.
//

import UIKit
import Alamofire

class HorarioService {
    
    static let shared = HorarioService()
    
    private let baseURL = "https://apiveterinaria-production-238b.up.railway.app/api/horarios"
    
    func listarHorariosPorVeterinario(idVet: Int, token: String, completion: @escaping (Result<[HorarioInfo], Error>) -> Void) {
        let url = "\(baseURL)/admin/historial/\(idVet)"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [HorarioInfo].self) { response in
                switch response.result {
                case .success(let horarios):
                    completion(.success(horarios))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func listarHorariosDisponibles(idVet: Int, token: String, completion: @escaping (Result<[HorarioInfo], Error>) -> Void) {
        let url = "\(baseURL)/disponibles/\(idVet)"
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json")
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [HorarioInfo].self) { response in
                switch response.result {
                case .success(let horarios):
                    completion(.success(horarios))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func registrarHorario(datos: HorarioRegister, token: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/admin"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .post, parameters: datos, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func actualizarHorario(idHorario: Int, datos: HorarioUpdate, token: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/admin/\(idHorario)"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .put, parameters: datos, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
