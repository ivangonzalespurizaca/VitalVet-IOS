//
//  AuthService.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 20/04/26.
//

import UIKit
import Alamofire

class AuthService {
    
    static let shared = AuthService()
    
    // 1. Definición de URLs Base
    private let googleURL = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA6cPVWVts1H5efEXPmYVDyPwaIpIBXpFw"
    private let railwayBaseURL = "https://apiveterinaria-production-238b.up.railway.app/api/public/auth"
    
    private let usuariosURL = "https://apiveterinaria-production-238b.up.railway.app/api/usuarios"
        
    func loginYSync(email: String, password: String, completion: @escaping (Result<UsuarioInfoDTO, Error>) -> Void) {
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            "returnSecureToken": true
        ]
        
        AF.request(googleURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let loginData = try JSONDecoder().decode(AuthResponse.self, from: data)
                        let token = loginData.idToken
                        
                        // Persistencia básica de sesión
                        UserDefaults.standard.set(token, forKey: "userToken")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        
                        self.sincronizarConRailway(token: token, completion: completion)
                    } catch {
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func registrarYPersistir(datos: UsuarioRegisterDTO, completion: @escaping (Result<UsuarioInfoDTO, Error>) -> Void) {
        // Uso de baseURL para el registro
        let url = "\(railwayBaseURL)/registrar"
        
        AF.request(url, method: .post, parameters: datos, encoder: JSONParameterEncoder.default)
            .response { response in
                if let code = response.response?.statusCode, (200...299).contains(code) {
                    self.sincronizarConRailway(token: datos.idToken, completion: completion)
                } else {
                    let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Error en el servidor de Railway"])
                    completion(.failure(error))
                }
            }
    }

    private func sincronizarConRailway(token: String, completion: @escaping (Result<UsuarioInfoDTO, Error>) -> Void) {
        // Uso de baseURL para la sincronización
        let url = "\(railwayBaseURL)/sync"
        let syncParams: [String: Any] = ["idToken": token]
        
        AF.request(url, method: .post, parameters: syncParams, encoding: JSONEncoding.default)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let usuario = try JSONDecoder().decode(UsuarioInfoDTO.self, from: data)
                        self.guardarDatosUsuarioLocal(usuario: usuario)
                        completion(.success(usuario))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    func actualizarFoto(userId: String, imagen: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "\(usuariosURL)/\(userId)/foto"
        guard let imageData = imagen.jpegData(compressionQuality: 0.2) else { return }
        
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
                    UserDefaults.standard.set(decodedResponse.fotoUrl, forKey: "userFotoUrl")
                    completion(.success(decodedResponse.fotoUrl))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func actualizarDatosUsuario(userId: String, datos: UsuarioUpdateDTO, completion: @escaping (Bool) -> Void) {
            let url = "\(usuariosURL)/\(userId)"
            let token = UserDefaults.standard.string(forKey: "userToken") ?? ""
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json"
            ]
            
            AF.request(url, method: .put, parameters: datos, encoder: JSONParameterEncoder.default, headers: headers)
                .response { [weak self] response in
                    if let code = response.response?.statusCode, (200...299).contains(code) {
                        self?.sincronizarConRailway(token: token) { result in
                            switch result {
                            case .success:
                                completion(true)
                            case .failure:
                                completion(false)
                            }
                        }
                    } else {
                        completion(false)
                    }
                }
        }
    
    private func guardarDatosUsuarioLocal(usuario: UsuarioInfoDTO) {
        let defaults = UserDefaults.standard
        defaults.set(usuario.idUsuario, forKey: "userId")
        defaults.set(usuario.rol, forKey: "userRol")
        defaults.set(usuario.nombres, forKey: "userNombre")
        defaults.set(usuario.apellidos, forKey: "userApellidos")
        defaults.set(usuario.email, forKey: "userEmail")
        defaults.set(usuario.celular, forKey: "userCelular")
        defaults.set(usuario.genero, forKey: "userGenero")
        defaults.set(usuario.fotoUrl, forKey: "userFotoUrl")
        defaults.set(usuario.dni, forKey: "userDni")
    }
}
