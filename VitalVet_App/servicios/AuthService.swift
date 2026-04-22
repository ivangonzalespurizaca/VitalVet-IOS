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
        
    func loginYSync(email: String, password: String, completion: @escaping (Result<UsuarioInfoDTO, Error>) -> Void) {
        print("1. Iniciando petición a Firebase...")
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            "returnSecureToken": true
        ]
        
        AF.request(googleURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseData { response in
                // --- BLOQUE DE DEPURACIÓN ---
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print(" --- CONTENIDO REAL DE FIREBASE ---")
                    print(utf8Text)
                    print("--------------------------------------")
                }
                
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

    private func sincronizarConRailway(token: String, completion: @escaping (Result<UsuarioInfoDTO, Error>) -> Void) {
        let syncParams: [String: Any] = ["idToken": token]
        
        AF.request(railwaySyncURL,
                   method: .post,
                   parameters: syncParams,
                   encoding: JSONEncoding.default) // Asegúrate de que sea JSONEncoding
            .responseData { response in // Cambiamos a responseData para ver el error crudo
                
                // --- ESTO TE DIRÁ QUÉ RESPONDE RAILWAY ---
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("--- RESPUESTA CRUDA DEL SERVIDOR ---")
                    print(utf8Text)
                    print("------------------------------------")
                }
                
                switch response.result {
                case .success(let data):
                    do {
                        let usuario = try JSONDecoder().decode(UsuarioInfoDTO.self, from: data)
                        let defaults = UserDefaults.standard
                        
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
                        // Aquí es donde Swift nos dirá si falta un campo
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print(" ERROR DE RED: \(error.localizedDescription)")
                    completion(.failure(error))
                }
        }
    }
}
