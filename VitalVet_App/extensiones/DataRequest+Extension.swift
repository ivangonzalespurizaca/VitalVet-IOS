//
//  DataRequest+Extension.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 28/04/26.
//

import Alamofire
import Foundation

extension DataRequest {
    // Este método intentará extraer el mensaje de tu APIError cuando el status no sea 200
    func responseVitalVet(completion: @escaping (Result<Void, Error>) -> Void) {
        self.response { response in
            // 1. Si es éxito (200-299)
            if let code = response.response?.statusCode, (200...299).contains(code) {
                completion(.success(()))
                return
            }
            
            // 2. Si es error, intentamos decodificar tu APIError
            if let data = response.data {
                do {
                    let apiError = try JSONDecoder().decode(APIError.self, from: data)
                    
                    // Priorizamos el diccionario de errores, si no, el mensaje simple
                    let mensaje = apiError.errors?.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
                                 ?? apiError.message
                                 ?? "Error desconocido"
                    
                    let errorCustom = NSError(domain: "", code: apiError.status ?? 400,
                                            userInfo: [NSLocalizedDescriptionKey: mensaje])
                    completion(.failure(errorCustom))
                } catch {
                    let errorServer = NSError(domain: "", code: 500,
                                            userInfo: [NSLocalizedDescriptionKey: "Error al procesar respuesta del servidor"])
                    completion(.failure(errorServer))
                }
            } else {
                completion(.failure(response.error ?? NSError(domain: "", code: 0)))
            }
        }
    }
}
