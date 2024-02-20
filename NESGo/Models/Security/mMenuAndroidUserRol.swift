//
//  mMenuWindows.swift
//  NESGo
//
//  Created by Guillermo Alvarez on 13/02/24.
//

import Foundation
import Combine
import SwiftUI
class clMenuAndroidUserRol : ObservableObject {

    private var WindowName : String = ""
    
    //CAMBIOS
    var didChange = PassthroughSubject<clMenuAndroidUserRol, Never>()
    @Published var MenuAndroidUserRolResult = stMenuApi(success: false, records: 0, message: "", messageDev: "", data: []){
        didSet {
            didChange.send(self)
        }
    }
    var didChangeUser = PassthroughSubject<clMenuAndroidUserRol, Never>()
    @Published var objDataUserResult = stUser(UserID: 0, User: "", FirstName: "", LastName: "", ChangePass: false, RolID: 0, Rol: ""){
        didSet {
            didChangeUser.send(self)
        }
    }
    
    
    init(WindowName: String) {
        self.WindowName = WindowName
    }
    
    func getMenuAndroidUserRol(){
        //UserDefaults
        let sUserData = UserDefaults.standard.object(forKey: "UserData") as! String
        let jsonDatax = Data(sUserData.utf8)
        let objUserData = try! JSONDecoder().decode(stUser.self, from: jsonDatax)
  
        //Variables de entorno
        let sUrlBase = ProcessInfo.processInfo.environment["ApiUrl"] ?? ""
        let sEnvironment = ProcessInfo.processInfo.environment["Environment"] ?? "0"
        let sApiToken = ProcessInfo.processInfo.environment["ApiToken"] ?? ""
        let sUserID = objUserData.UserID
        
       // Asignamos valores a la clase
        let bIsAdmin = objUserData.RolID == 1 ? true : false
        let objMenu = stMenuRequest(RolID: objUserData.RolID, UserID: objUserData.UserID, IsAdmin: bIsAdmin)
        guard let url = URL(string: "\(sUrlBase)Security/MenuAndroidUserRol") else { return }
       
        let jsonData = try! JSONEncoder().encode(objMenu)
        guard let sParametros = String(data: jsonData, encoding: String.Encoding.utf8) else { return }
        
        //Creamos Request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(sParametros, forHTTPHeaderField:  "Parameters")
        request.setValue(sEnvironment, forHTTPHeaderField: "Environment")
        request.setValue(sApiToken, forHTTPHeaderField: "Authorization")
        request.setValue(String(sUserID), forHTTPHeaderField: "UserID")
        request.setValue(self.WindowName, forHTTPHeaderField: "WindowName")
        
        URLSession.shared.dataTask(with: request) { urldata, response, error in
            do{
                guard let datax = urldata else { return }
                let decodedData = try JSONDecoder().decode(stMenuApi.self, from: datax)
                DispatchQueue.main.sync {
                    self.objDataUserResult = objUserData
                    self.MenuAndroidUserRolResult = decodedData
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
            
        }.resume()
    }
    
}
    struct stMenuRequest : Codable, Hashable {
        var RolID : Int
        var UserID : Int
        var IsAdmin : Bool
    }
    
    struct stMenuApi : Decodable {
        var success : Bool
        //var date : String
        var records : Int
        var message : String
        var messageDev : String
        var data : [stMenu]
    }

struct stMenu : Decodable, Hashable {
    var MenuAndroidID : Int
    var ViewName : String
    var DescriptionMenu : String
    var AreaID : Int
    var Area : String
    var IsActive : Bool
}
    
    
