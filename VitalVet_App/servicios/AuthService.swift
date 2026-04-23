//
//  AuthService.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 20/04/26.
//

import UIKit
import Alamofire

class AuthService {
    
    // URLs
    let googleURL = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA6cPVWVts1H5efEXPmYVDyPwaIpIBXpFw"
    let railwaySyncURL = "https://apiveterinaria-production-238b.up.railway.app/api/public/auth/sync"
    let railwayRegisterURL = "https://apiveterinaria-production-238b.up.railway.app/api/public/auth/registrar"
        
    func loginYSync(email: String, password: String, completion: @escaping (Result<UsuarioInfoDTO, Error>) -> Void) {
        print("1. Iniciando petición a Firebase...")
        
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
                        // Intentamos decodificar manualmente aquí
                        let loginData = try JSONDecoder().decode(AuthResponse.self, from: data)
                        let token = loginData.idToken
                        UserDefaults.standard.set(token, forKey: "userToken")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        
                        print(" 2. Token obtenido correctamente.")
                        self.sincronizarConRailway(token: token, completion: completion)
                    } catch {
                        print(" 3. ERROR DE DECODIFICACIÓN: \(error)")
                        // Aquí es donde Xcode nos dirá qué campo falta o está mal
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print(" 4. ERROR DE RED/FIREBASE: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
    
    
    func registrarYPersistir(datos: UsuarioRegisterDTO, completion: @escaping (Result<UsuarioInfoDTO, Error>) -> Void) {
        AF.request(railwayRegisterURL, method: .post, parameters: datos, encoder: JSONParameterEncoder.default)
            .response { response in
                // --- AÑADE ESTO PARA VER EL ERROR REAL ---
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("DEBUG RAILWAY: \(utf8Text)")
                }
                // -----------------------------------------

                if let code = response.response?.statusCode, (200...299).contains(code) {
                    self.sincronizarConRailway(token: datos.idToken, completion: completion)
                } else {
                    let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Error en el servidor de Railway"])
                    completion(.failure(error))
                }
            }
    }

    private func sincronizarConRailway(token: String, completion: @escaping (Result<UsuarioInfoDTO, Error>) -> Void) {
        let syncParams: [String: Any] = ["idToken": token]
        
        AF.request(railwaySyncURL,
                   method: .post,
                   parameters: syncParams,
                   encoding: JSONEncoding.default)
            .responseData { response in
                
                switch response.result {
                case .success(let data):
                    do {
                        let usuario = try JSONDecoder().decode(UsuarioInfoDTO.self, from: data)
                        let defaults = UserDefaults.standard
                        defaults.set(usuario.idUsuario, forKey: "userId")
                        defaults.set(usuario.rol, forKey: "userRol")
                        defaults.set(usuario.nombres, forKey: "userNombre")
                        defaults.set(usuario.apellidos, forKey: "userApellidos")
                        defaults.set(usuario.email, forKey: "userEmail")
                        defaults.set(usuario.celular, forKey: "userCelular")
                        defaults.set(usuario.genero, forKey: "userGenero")
                        defaults.set(usuario.fotoUrl, forKey: "userFotoUrl")
                        
                        completion(.success(usuario))
                    } catch {
                        print(" ERROR AL DECODIFICAR: \(error)")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print(" ERROR DE RED: \(error.localizedDescription)")
                    completion(.failure(error))
                }
        }
    }
    
}
