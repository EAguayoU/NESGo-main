//
//  Tools.swift
//  NESGo
//
//  Created by Guillermo Alvarez on 08/02/24.
//

import Foundation
import SwiftUI
import WebKit

extension Color {
    init(hex: String){
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
        
    }
}

extension URLSession {
    
    func syncRequest(request: URLRequest) -> (data: Data?, response: URLResponse?, error: Error?){
        
        let semaphore = DispatchSemaphore(value: 0)
        var data: Data?
        var response : URLResponse?
        var error : Error?
        
        let task = self.dataTask(with: request){
            data = $0
            response = $1
            error = $2
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
        return (data,response,error)
    }
}

func gpDatosUsuario() -> stUser {
    guard let sUserData = UserDefaults.standard.object(forKey: "UserData") as? String else{
        return stUser(UserID: 0, User: "", FirstName: "", LastName: "", ChangePass: false, RolID: 0, Rol: "")
    }
    let jsonDatax = Data(sUserData.utf8)
    let objUserData = try! JSONDecoder().decode(stUser.self, from: jsonDatax)
    return objUserData
}

struct HourGlass: UIViewRepresentable{
    private let name: String
    init(_ name: String) {
        self.name = name
    }
    func makeUIView(context: Context) -> WKWebView{
        let webView = WKWebView()
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        
        webView.load(
            data,
            mimeType: "image/gif",
            characterEncodingName: "UTF-8",
            baseURL: url.deletingLastPathComponent())
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}




