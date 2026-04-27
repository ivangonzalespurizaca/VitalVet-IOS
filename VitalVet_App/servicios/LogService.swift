//
//  LogService.swift
//  VitalVet_App
//
//  Created by XCODE on 27/04/26.
//

import Foundation
import Alamofire

class LogService {
    static let shared = LogService()
        
        // Base URL según tu backend en producción
        private let baseURL = "https://apiveterinaria-production-238b.up.railway.app/api/admin/logs"
        
        func listarLogs(inicio: String?, fin: String?, token: String, completion: @escaping (Result<[LogDTO], Error>) -> Void) {
            
            let headers: HTTPHeaders = [
                .authorization(bearerToken: token),
                .accept("application/json")
            ]
            
            // Configurar los parámetros de consulta (Query Params)
            var parameters: [String: String] = [:]
            if let fechaInicio = inicio, let fechaFin = fin {
                parameters["inicio"] = fechaInicio
                parameters["fin"] = fechaFin
            }
            
            AF.request(baseURL, method: .get, parameters: parameters, headers: headers)
                .validate()
                .responseDecodable(of: [LogDTO].self) { response in
                    switch response.result {
                    case .success(let logs):
                        completion(.success(logs))
                    case .failure(let error):
                        // Manejo específico para el código 204 No Content del backend
                        if response.response?.statusCode == 204 {
                            completion(.success([]))
                        } else {
                            completion(.failure(error))
                        }
                    }
                }
        }
}
