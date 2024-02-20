//
//  clApiRequest.swift
//  NESGo
//
//  Created by Guillermo Alvarez on 08/02/24.
//

import Foundation
import SwiftUI
import Combine

class clApiRequest : ObservableObject {
    //Variables
    var sUrl : String = ""
    var nEnvironment : Int = 0
    var sBody : [String:String]? = nil
    var sMethod : String = ""
    
    //Control
    var didChange = PassthroughSubject<clApiRequest,Never>()
    @Published var  objResponse = clApiResponse(){
        didSet {
            didChange.send(self)
        }
    }
    
}
