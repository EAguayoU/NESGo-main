//
//  mWarehouse.swift
//  NESGo
//
//  Created by Erik Aguayo on 20/02/24.
//

import Foundation
import Combine
import SwiftUI

class clWarehouse : ObservableObject {
    private var WindowName : String = ""
    //CAMBIOS
    var didChange = PassthroughSubject<clWarehouse, Never>()
    @Published var WarehouseResult = stWarehouseApi(success: false, records: 0, message: "", messageDev: "", data: []){
        didSet {
            didChange.send(self)
        }
    }
    
    init(WindowName: String) {
        self.WindowName = WindowName
    }
    
    func getWarehouse(objWarehouse : stWarehouseRequest){
        
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
        guard let url = URL(string: "\(sUrlBase)Warehouse/Warehouse") else { return }
        let jsonData = try! JSONEncoder().encode(objWarehouse)
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
                let decodedData = try JSONDecoder().decode(stWarehouseApi.self, from: datax)
 
                DispatchQueue.main.sync {
                    self.WarehouseResult = decodedData
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

struct stWarehouseRequest: Codable, Hashable{
    var WarehouseID : Int?
    var IsActive : Bool?
    var IsSalesWarehouse : Bool?
    var IsShipping : Bool?
    
}

struct stWarehouseApi: Decodable{
    var success : Bool
    var records : Int
    var message : String
    var messageDev : String
    var data : [stWarehouse]
    
}

struct stWarehouse : Decodable, Hashable{
    var WarehouseID: Int
    var WarehouseDescription: String
    var WarehouseCodeDescription: String
    var WarehouseAlias: String?
    var WarehouseAddress1: String
    var WarehouseAddress2: String
    var CityName: String
    var WarehouseState: String
    var WarehouseZip: String
    var WarehouseCountryID : Int
    var WarehouseCountry: String
    var Address1: String
    var Address2: String
    var Address3: String
    var ShortCode: String
    var IsActive: Bool
    var WarehouseCode: String
    var IsSalesWarehouse: Bool
}
