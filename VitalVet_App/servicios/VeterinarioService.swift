//
//  VeterinarioService.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 23/04/26.
//

import UIKit
import Alamofire

class VeterinarioService {
    
    static let shared = VeterinarioService()

    private let baseURL = "https://apiveterinaria-production-238b.up.railway.app/api/admin/veterinarios"

    func listarVeterinarios(token: String, completion: @escaping (Result<[VeterinarioInfo], Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]

        AF.request(baseURL, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [VeterinarioInfo].self) { response in
                completion(response.result.mapError { $0 as Error })
            }
    }
    
    func registrarVeterinario(datos: VeterinarioRegister, token: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]

        AF.request(baseURL, method: .post, parameters: datos, encoder: JSONParameterEncoder.default, headers: headers)
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
    
    func actualizarVeterinario(id: Int, datos: VeterinarioUpdate, token: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/\(id)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]

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
