//
//  ConsultaService.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 29/04/26.
//

import UIKit
import Alamofire

class ConsultaService: NSObject {

    static let shared = ConsultaService()
    
    func registrarConsultaEnServidor(datos: ConsultaRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            let errorToken = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Sesión expirada"])
            completion(.failure(errorToken))
            return
        }
        
        let url = "https://apiveterinaria-production-238b.up.railway.app/api/consultas/registrar"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        // Llamada usando tu extensión personalizada
        AF.request(url, method: .post, parameters: datos, encoder: JSONParameterEncoder.default, headers: headers)
            .responseVitalVet { result in
                completion(result)
            }
    }
    
}
