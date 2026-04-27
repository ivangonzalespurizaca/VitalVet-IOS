//
//  CitaService.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 26/04/26.
//

import UIKit
import Alamofire

class CitaService: NSObject {

    static let shared = CitaService()
    private let baseURL = "https://apiveterinaria-production-238b.up.railway.app/api/citas"
        
    func consultarDisponibilidad(idVet: Int, fecha: String, token: String, completion: @escaping (Result<[SlotHorario], Error>) -> Void) {
        let url = "\(baseURL)/disponibilidad"
        let parameters: [String: Any] = [
            "idVeterinario": idVet,
            "fecha": fecha
        ]
        
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .responseDecodable(of: [SlotHorario].self) { response in
                switch response.result {
                case .success(let slots):
                    completion(.success(slots))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func registrarCita(datos: CitaRegister, token: String, completion: @escaping (Result<CitaInfo, Error>) -> Void) {
        let url = "\(baseURL)/registrar"
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        
        AF.request(url, method: .post, parameters: datos, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: CitaInfo.self) { response in
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Respuesta cruda del servidor: \(utf8Text)")
                        }
                
                switch response.result {
                    case .success(let cita):
                        completion(.success(cita))
                    case .failure(let error):
                        if let data = response.data,
                            let serverError = try? JSONDecoder().decode(APIError.self, from: data) {
                            
                            let detalleEspecifico = serverError.errors?.values.first
                                    
                            let mensajeFinal = detalleEspecifico ?? serverError.message ?? "Error desconocido"
                            
                            let errorCustom = NSError(
                                domain: "VitalVet",
                                code: serverError.status ?? 500,
                                userInfo: [NSLocalizedDescriptionKey: mensajeFinal]
                            )
                            completion(.failure(errorCustom))
                        } else {
                            completion(.failure(error))
                        }
                    }
                }
    }

    func buscarCitasPorClienteYEstado(idCliente: String, estado: String, token: String, completion: @escaping (Result<[CitaInfo], Error>) -> Void) {
        let url = "\(baseURL)/cliente/\(idCliente)/estado/\(estado)"
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: [CitaInfo].self) { response in
                switch response.result {
                case .success(let citas):
                    completion(.success(citas))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func buscarCitasPorCliente(idCliente: String, token: String, completion: @escaping (Result<[CitaInfo], Error>) -> Void) {
        let url = "\(baseURL)/cliente/\(idCliente)"
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: [CitaInfo].self) { response in
                switch response.result {
                case .success(let citas):
                    completion(.success(citas))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func cancelarCita(idCita: Int, motivo: String, token: String, completion: @escaping (Result<CitaInfo, Error>) -> Void) {
        let url = "\(baseURL)/\(idCita)/cancelar"
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        let body = CitaCancel(motivo: motivo)
        
        AF.request(url, method: .put, parameters: body, encoder: JSONParameterEncoder.default, headers: headers)
            .responseDecodable(of: CitaInfo.self) { response in
                switch response.result {
                case .success(let citaCancelada):
                    completion(.success(citaCancelada))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func listarVeterinariosDisponibles(token: String, completion: @escaping (Result<[VeterinarioInfo], Error>) -> Void) {
        let url = "\(baseURL)/veterinarios-disponibles"
        let headers: HTTPHeaders = [.authorization(bearerToken: token)]
        
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: [VeterinarioInfo].self) { response in
                switch response.result {
                case .success(let vets):
                    completion(.success(vets))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}
