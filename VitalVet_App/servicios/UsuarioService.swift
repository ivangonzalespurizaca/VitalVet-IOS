//
//  UsuarioService.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 27/04/26.
//

import UIKit
import Alamofire

class UsuarioService: NSObject {
    
    
    // Al inicio de la clase, añade la URL base para usuarios
    private let usuariosURL = "https://apiveterinaria-production-238b.up.railway.app/api/usuarios"

    func actualizarFoto(userId: String, imagen: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(usuariosURL)/\(userId)/foto"
        guard let imageData = imagen.jpegData(compressionQuality: 0.5) else { return }
        
        let token = UserDefaults.standard.string(forKey: "userToken") ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file", fileName: "perfil.jpg", mimeType: "image/jpeg")
        }, to: url, method: .patch, headers: headers).responseData { response in
            // Debug: Imprime el código de estado para saber qué dice el servidor
            if let code = response.response?.statusCode {
                print("Status Code Foto: \(code)")
            }

            switch response.result {
            case .success(let data):
                do {
                    let decodedResponse = try JSONDecoder().decode(FotoResponse.self, from: data)
                    completion(.success(decodedResponse.fotoUrl))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

