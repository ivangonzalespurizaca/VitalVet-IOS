//
//  ApiError.swift
//  VitalVet_App
//
//  Created by Oscar Ivan Gonzales Purizaca on 26/04/26.
//

import UIKit

nonisolated
struct APIError: Codable {
    let status: Int?
    let message: String?
    let timestamp: String?
    let errors: [String: String]?
}
