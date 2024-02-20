//
//  mLedger.swift
//  NESGo
//
//  Created by Erik Aguayo on 19/02/24.
//

import Foundation
import Combine
import SwiftUI

class clLedger : ObservableObject {
    private var WindowName : String = ""
    //CAMBIOS
    var didChange = PassthroughSubject<clLedger, Never>()
    @Published var LedgerResult = stLedgerApi(success: false, records: 0, message: "", messageDev: "", data: []){
        didSet {
            didChange.send(self)
        }
    }
  
    init(WindowName: String) {
        self.WindowName = WindowName
    }
    
    func getLedger(objLedger : stLedgerRequest){
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
        //let bIsAdmin = objUserData.RolID == 1 ? true : false
        guard let url = URL(string: "\(sUrlBase)WMS/Ledger") else { return }
        let jsonData = try! JSONEncoder().encode(objLedger)
        guard let sParametros = String(data: jsonData, encoding: String.Encoding.utf8) else { return }
        
        //Creamos Request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(sParametros, forHTTPHeaderField:  "Parameters")
        request.setValue(sEnvironment, forHTTPHeaderField: "Environment")
        request.setValue(sApiToken, forHTTPHeaderField: "Authorization")
        request.setValue(String(sUserID), forHTTPHeaderField: "UserID")
        request.setValue(self.WindowName, forHTTPHeaderField: "WindowName")
        print(sParametros)
        URLSession.shared.dataTask(with: request) { urldata, response, error in
            do{
                //print(request)
                guard let datax = urldata else { return }
                let decodedData = try JSONDecoder().decode(stLedgerApi.self, from: datax)
                //print(decodedData)
                DispatchQueue.main.sync {
                    self.LedgerResult = decodedData
                    print(self.LedgerResult)
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

struct stLedgerRequest : Codable, Hashable {
    var Document : String?
    var StartDate : String
    var EndDate : String
    var MovementTypeID : Int
    var ItemSecondCode : String?
    var WarehouseID : Int
}

struct stLedgerApi : Decodable {
    var success : Bool
    var records : Int
    var message : String
    var messageDev : String
    var data : [stLedger]
}

struct stLedger : Decodable, Hashable {
    var ItemSecondCode : String
    var TransactionDate : String
    var TransactionTime : String
    var MovementType : String
    var Document : String
    var Location : String
    var Note : String
    var UserName : String
    var Quantity : Int
    var InitialInventory : Int
    var FinalInventory : Int
}
