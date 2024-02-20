//
//  mMovementType.swift
//  NESGo
//
//  Created by Erik Aguayo on 20/02/24.
//

import Foundation
import Combine
import SwiftUI

class clMovementType : ObservableObject {
    private var WindowName : String = ""
    //CAMBIOS
    var didChange = PassthroughSubject<clMovementType, Never>()
    @Published var MovementTypeResult = stMovementTypeApi(success: false, records: 0, message: "", messageDev: "", data: []){
        didSet {
            didChange.send(self)
        }
    }
    
    init(WindowName: String) {
        self.WindowName = WindowName
    }
    
    func getMovementType(){
        
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
        guard let url = URL(string: "\(sUrlBase)WMS/MovementType") else { return }
       
        
        //Creamos Request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("{}", forHTTPHeaderField:  "Parameters")
        request.setValue(sEnvironment, forHTTPHeaderField: "Environment")
        request.setValue(sApiToken, forHTTPHeaderField: "Authorization")
        request.setValue(String(sUserID), forHTTPHeaderField: "UserID")
        request.setValue(self.WindowName, forHTTPHeaderField: "WindowName")
    
        URLSession.shared.dataTask(with: request) { urldata, response, error in
            do{
                guard let datax = urldata else { return }
                let decodedData = try JSONDecoder().decode(stMovementTypeApi.self, from: datax)
                DispatchQueue.main.sync {
                    self.MovementTypeResult = decodedData
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

struct stMovementTypeApi: Decodable{
    var success : Bool
    var records : Int
    var message : String
    var messageDev : String
    var data : [stMovementType]
    
}
struct stMovementType : Decodable, Hashable{
    var MovementTypeID : Int
    var MovementType : String
}

