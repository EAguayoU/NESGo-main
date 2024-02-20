//
//  clUser.swift
//  NESGo
//
//  Created by Guillermo Alvarez on 09/02/24.
//

import Foundation
import Combine
import SwiftUI

class clUser : ObservableObject {
    
    private var WindowName : String = ""
    
    //CAMBIOS
    var didChange = PassthroughSubject<clUser, Never>()
    @Published var UserResult = stUserApi(success: false, records: 0, message: "", messageDev: "", data: []){
        didSet {
            didChange.send(self)
        }
    }
    
    init(WindowName: String) {
        self.WindowName = WindowName
    }
   
    func getUser(User: String, Password: String){
        //Variables de entorno
        let sUrlBase = ProcessInfo.processInfo.environment["ApiUrl"] ?? ""
        let sEnvironment = ProcessInfo.processInfo.environment["Environment"] ?? "0"
        let sApiToken = ProcessInfo.processInfo.environment["ApiToken"] ?? ""
        let sUserID = "1"
        
        //Creamos Request
        guard let url = URL(string: "\(sUrlBase)Security/User") else { return }
        let objLogin = stLoginRequest(User: User, Pass2: Password)
        let jsonData = try! JSONEncoder().encode(objLogin)
        guard let sParametros = String(data: jsonData, encoding: String.Encoding.utf8) else { return }
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
                    guard let datax = data else { return }
                    let decodedData = try JSONDecoder().decode(stUserApi.self, from: datax)
                    self.UserResult = decodedData
                                        
                    if(!self.UserResult.success){
                        self.UserResult.message = ""
                    }
                }
                else
                {
                    UserResult.message = "No se pudo obtener respuesta del servidor, inténtelo de nuevo mas tarde (error \(httpResponse.statusCode))"
                }
            }
            else
            {
                UserResult.message = "No se pudo obtener respuesta del servidor, inténtelo de nuevo mas tarde (unknow)"
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
    }
}

    struct stLoginRequest : Codable {
        var User : String
        var Pass2 : String
    }
    
    struct stUserApi : Decodable {
        var success : Bool
        //var date : String
        var records : Int
        var message : String
        var messageDev : String
        var data : [stUser]
    }
    
    struct stUser : Decodable, Encodable {
            var UserID : Int
            var User : String
            var FirstName : String
            var LastName : String
            var ChangePass : Bool
            var Email : String?
            var RolID : Int
            var Rol : String
    }

