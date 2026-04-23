//
//  EnunService.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 22/04/26.
//

import UIKit
import Alamofire

class EnumService{
    
    let enumsGenerosURL = "https://apiveterinaria-production-238b.up.railway.app/api/public/enums/generos"

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

}
