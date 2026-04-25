//
//  AuthService.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 20/04/26.
//

import UIKit
import Alamofire

class AuthService {
    
    // 1. Definición de URLs Base
    private let googleURL = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA6cPVWVts1H5efEXPmYVDyPwaIpIBXpFw"
    private let railwayBaseURL = "https://apiveterinaria-production-238b.up.railway.app/api/public/auth"
        
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
    }
}
