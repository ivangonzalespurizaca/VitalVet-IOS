//
//  EnunService.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 22/04/26.
//

import UIKit
import Alamofire

class EnumService{
    
    static let shared = EnumService()
    
    let enumsGenerosURL = "https://apiveterinaria-production-238b.up.railway.app/api/public/enums/generos"
    
    let enumsEspecialidadesURL = "https://apiveterinaria-production-238b.up.railway.app/api/public/enums/especialidades"

    func obtenerGeneros(completion: @escaping ([String]?) -> Void) {
        AF.request(enumsGenerosURL).responseDecodable(of: [String].self) { response in
            switch response.result {
            case .success(let generos):
                completion(generos)
            case .failure:
                completion(nil)
            }
        }
    }
    
    func obtenerEspecialidades(completion: @escaping ([String]?) -> Void) {
        AF.request(enumsEspecialidadesURL).responseDecodable(of: [String].self) { response in
            switch response.result {
            case .success(let especialidades):
                completion(especialidades)
            case .failure:
                completion(nil)
            }
        }
    }

}
