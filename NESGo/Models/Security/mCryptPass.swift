//
//  mCryptPass.swift
//  NESGo
//
//  Created by Guillermo Alvarez on 12/02/24.
//

import Foundation
import Combine
import SwiftUI

class clCryptPass : ObservableObject {
    
    private var WindowName : String = ""
   
    init(WindowName: String) {
        self.WindowName = WindowName
    }
    
    
    func getCryptPass(sPassword: String) -> String{
       
        //Variables de entorno
        let sUrlBase = ProcessInfo.processInfo.environment["ApiUrl"] ?? ""
        let sEnvironment = ProcessInfo.processInfo.environment["Environment"] ?? "0"
        let sApiToken = ProcessInfo.processInfo.environment["ApiToken"] ?? ""
        let sUserID = "1"
        
        //Creamos Request
        guard let url = URL(string: "\(sUrlBase)Security/CryptPass") else { return "" }
        let sParametros = "{\"Text\":\"\(sPassword)\"}"
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(sParametros, forHTTPHeaderField:  "Parameters")
        request.setValue(sEnvironment, forHTTPHeaderField: "Environment")
        request.setValue(sApiToken, forHTTPHeaderField: "Authorization")
        request.setValue(sUserID, forHTTPHeaderField: "UserID")
        request.setValue(self.WindowName, forHTTPHeaderField: "WindowName")
        
        let (data, response, _) = Foundation.URLSession.shared.syncRequest(request: request)
        do{
        
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200)
                {
                    guard let datax = data else { return "" }
                    let decodedData = try JSONDecoder().decode(stPasswordApi.self, from: datax)
                    if(decodedData.success){
                        return decodedData.data
                    }
                }
            }
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let error as NSError {
            print("Error al ejecutar el api", error.localizedDescription)
        }
        
        return ""
    }
}

struct stPasswordApi : Decodable {
    var success : Bool
    var date : String
    var records : Int
    var message : String
    var messageDev : String
    var data : String
}
