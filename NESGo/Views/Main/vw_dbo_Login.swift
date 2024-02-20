//
//  vw_dbo_Start2.swift
//  NESGo
//
//  Created by Guillermo Alvarez on 15/02/24.
//

import SwiftUI

struct vw_dbo_Login: View {
    
    //Controles
    @State var bHourGlass : Bool = false
    @State var bLogin : Bool
    @State var sUsuario : String = ""
    @State var sPassword : String = ""
    @State var bGuardar : Bool = false
    @State private var cUsuario : Color = .blue
    @State private var cPassword : Color = .blue
    @State private var bAlerta : Bool = false
    @State private var sAlerta : String = ""
    
    //Api Conexion
    @ObservedObject var objLoginUserApi = clUser(WindowName: "vw_scr_Login")
    var objCryptPass = clCryptPass(WindowName: "vw_scr_Login")

    //Version
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                Image("NESGO-120")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .aspectRatio(contentMode: .fit)
                Text("Mobile")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, -15)
                Spacer()
                
                VStack(alignment: .leading, content: {
                    HStack(alignment: .top, content: {
                        Image(systemName: "person.circle")
                        Text("Usuario")
                            .foregroundColor(.black)
                    })
                    TextField("Ingrese su usuario", text: self.$sUsuario)
                        .autocapitalization(.allCharacters)
                        .frame(width: 360, height: 40)
                        .border(cUsuario)
                        .onChange(of: self.sUsuario){
                            if(sUsuario.isEmpty){
                                cUsuario = .red
                            }
                            else {
                                cUsuario = .blue
                            }
                        }
                })
                .padding(.top, 50)
                
                VStack(alignment: .leading, content: {
                    HStack(alignment: .top, content: {
                        Image(systemName: "lock.circle")
                        Text("Contraseña").foregroundColor(.black)
                    })
                    SecureField("Ingrese su contraseña", text: self.$sPassword)
                        .frame(width: 360, height: 40)
                        .border(cPassword)
                        .onChange(of: self.sPassword){
                            if(sPassword.isEmpty){
                                cPassword = .red
                            }
                            else{
                                cPassword = .blue
                            }
                        }
                    
                })
                .padding(.top,40)
                
                Toggle(isOn: self.$bGuardar, label: {
                    Text("Mantener mi sesión abierta")
                })
                .frame(width: 360, height: 40)
                .padding(.top, 20)
                .padding(.bottom,30)
                .tint(Color(hex: "#a5c3e3"))
                
                HStack{
                    if bAlerta {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                        Text(sAlerta)
                            .bold()
                            .foregroundColor(.red)
                    }
                }
                .padding(.bottom,20)
                
                //Aceptar botón
                HStack(alignment: .center, content: {
                    Button(action: {
                        bHourGlass = true
                        if(pRequeridos()){
                            //Cryptpass
                            //HourGlass("Cargando")
                            let sPass : String = objCryptPass.getCryptPass(sPassword: sPassword)
                            objLoginUserApi.getUser(User: sUsuario, Password: sPass)
                            if(objLoginUserApi.UserResult.success){
                                //Logueado
                                //Guardamos todos los datos del usuario
                                let jsonData = try! JSONEncoder().encode(objLoginUserApi.UserResult.data[0])
                                guard let sUserData = String(data: jsonData, encoding: String.Encoding.utf8) else { return }
                                
                                UserDefaults.standard.set(self.bGuardar, forKey: "Guardado")
                                UserDefaults.standard.set(sUserData, forKey: "UserData")
                                
                                bLogin = true
                                bAlerta = false
                            }
                            else
                            {
                                bLogin = false
                                bAlerta = true
                                sAlerta = objLoginUserApi.UserResult.message == "" ? "Usuario/Contraseña incorrecto" : objLoginUserApi.UserResult.message
                            }
                        }
                    }, label: {
                        HStack(alignment: .center,content: {
                            Spacer()
                            Text("Aceptar")
                            Spacer()
                        }).padding(.all)
                    })
                    
                    .modifier(btnClaro())
                })
                .padding(.leading,20)
                .padding(.trailing,20)
                
                //Segungo botón
                HStack(alignment: .center, content: {
                    Button(action: {
                        
                        bAlerta = false
                    }, label: {
                        HStack(alignment: .center,content: {
                            Spacer()
                            Text("Salir")
                            Spacer()
                        }).padding(.all)
                    })
                    .modifier(btnNice())
                    
                })
                .padding(.bottom,20)
                .padding(.leading,20)
                .padding(.trailing,20)
                
                //Version
                HStack(content: {
                    Text("Versión: \(appVersion)")
                        .padding(20)
                    Spacer()
                })
                
            }
            .foregroundStyle(Color(hex: "#002D57"))
            .onAppear(perform: pSesionAbierta)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $bLogin) {
                vw_dbo_Principal(bLogin: $bLogin)
                .navigationBarBackButtonHidden(true)
            }
            
        }
    }
    
    func pRequeridos() -> Bool
    {
        var nRequeridos = 0
        if (sUsuario.isEmpty)
        {
            nRequeridos += 1
            cUsuario = .red
        }
        if (sPassword.isEmpty)
        {
            nRequeridos += 1
            cPassword = .red
        }
        
        if (nRequeridos == 0)
        {
            self.bAlerta = false
            sAlerta = ""
            return true
        }
        else
        {
            self.bAlerta = true
            sAlerta = "Ingrese usuario y contraseña para continuar"
            return false
        }
    }
    
    func pSesionAbierta(){
        if(UserDefaults.standard.object(forKey: "Guardado") != nil ){
            self.bGuardar =  UserDefaults.standard.object(forKey: "Guardado") as! Bool
            if(UserDefaults.standard.object(forKey: "UserData") != nil){
                if (self.bGuardar != false){
                    bLogin = true
                }
                else{
                    bLogin = false
                }
            }
        }else{
            UserDefaults.standard.removeObject(forKey: "UserData")
            UserDefaults.standard.removeObject(forKey: "Guardado")
            self.bGuardar = false
            self.sUsuario = ""
            self.sPassword = ""
            bLogin = false
        }
    }
}

#Preview {
    vw_dbo_Login(bLogin: false)
}
