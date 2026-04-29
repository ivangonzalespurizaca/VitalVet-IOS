//
//  VacunaService.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 29/04/26.
//

import UIKit
import Alamofire

class VacunaService: NSObject {

    static let shared = VacunaService() // Singleton para fácil acceso
        private let baseURL = "https://apiveterinaria-production-238b.up.railway.app/api/vacunas-aplicadas"

        func programarVacuna(idMascota: Int, datos: [String: Any], token: String, completion: @escaping (Result<Void, Error>) -> Void) {
            
            let url = "\(baseURL)/mascota/\(idMascota)/programar"
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]

            // Usamos JSONEncoding.default porque enviamos un diccionario [String: Any]
            AF.request(url, method: .post, parameters: datos, encoding: JSONEncoding.default, headers: headers)
                .responseVitalVet { result in
                    completion(result)
                }
        }
}
