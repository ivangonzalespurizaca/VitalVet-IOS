//
//  MascotaService.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 26/04/26.
//

import UIKit
import Alamofire

class MascotaService{
    static let shared = MascotaService()
        private let baseURL = "https://apiveterinaria-production-238b.up.railway.app/api/mascotas"
        
        private init() {}
        
        func listarMascotasPorCliente(idCliente: String, token: String, completion: @escaping (Result<[Mascota], Error>) -> Void) {
            
            let url = "\(baseURL)/cliente/\(idCliente)"
            
            let headers: HTTPHeaders = [
                .authorization(bearerToken: token),
                .accept("application/json")
            ]
            
            AF.request(url, method: .get, headers: headers)
                .validate() // Valida que el status code esté entre 200-299
                .responseDecodable(of: [Mascota].self) { response in
                    switch response.result {
                    case .success(let mascotas):
                        completion(.success(mascotas))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
}
