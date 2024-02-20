//
//  clApiResponse.swift
//  NESGo
//
//  Created by Guillermo Alvarez on 08/02/24.
//

import Foundation

struct clApiResponse {
    
    var success : Bool = false
    var message : String = ""
    var messageDev : String = ""
    var data : String = ""
    var records : Int = 0
    var recordsError : Int = 0
    var executionTime : String = ""
}
