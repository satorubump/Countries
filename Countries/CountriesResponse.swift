//
//  CountriesResponse.swift
//  Countries
//
//  Created by Satoru Ishii on 4/27/25.
//

import Foundation

struct CountriesResponse : Codable {
    let name : String
    let region : String
    let code : String
    let capital : String
    
    enum CodingKeys : String, CodingKey {
        case name
        case region
        case code
        case capital
    }
}
