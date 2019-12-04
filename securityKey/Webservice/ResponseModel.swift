//
//  ResponseModel.swift
//  securityKey
//
//  Created by praveenkumar on 26/11/19.
//  Copyright © 2019 praveenkumar. All rights reserved.
//

import Foundation

struct ResponseModel: Codable {
    
    let id: String?
    
    var encrypted: Data
}


