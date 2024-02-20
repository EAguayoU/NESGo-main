//
//  vw_dbo_SideBar.swift
//  NESGo
//
//  Created by Guillermo Alvarez on 13/02/24.
//

import SwiftUI

struct vw_dbo_Sliding : View {
    @State var bCerrarSesion : Bool = false
    @Binding var bLogin : Bool
    @State var bGuardar : Bool = false
    
    @ObservedObject var objMenuWindowsApi = clMenuAndroidUserRol(WindowName: "vw_dbo_Sliding")
    @State var objDataUser = stUser(UserID: 0, User: "", FirstName: "", LastName: "", ChangePass: false, RolID: 0, Rol: "")
    
    @State var sBuscar : String = ""
    var objResults : [stMenu]{
        sBuscar.isEmpty ? objMenuWindowsApi.MenuAndroidUserRolResult.data : objMenuWindowsApi.MenuAndroidUserRolResult.data.filter { $0.DescriptionMenu.localizedCaseInsensitiveContains(sBuscar) }
    }
    var body: some View {
        VStack{
            NavigationView{
                VStack(alignment: .leading, content:{
                    HStack(alignment: .top){
                        Image("Usuario")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 90)
                            .background(.blue)
                            .clipShape(Circle())
                            .foregroundStyle(.white)
                        VStack(alignment: .leading){
                            Text("Nombre")
                                .frame(width: 65, height: 15)
                                .bold()
                                .padding(.top,20)
                            Text("Erik Aguayo")
                                .frame(width: 140, height: 15, alignment: .leading)
                                .padding(.top, 10)
                        }
                        VStack(alignment: .leading){
                            Text("Rol")
                                .frame(width: 100, height: 15,alignment: .leading)
                                .bold()
                                .padding(.top,20)
                            
                            Text("Invitado")
                                .frame(width: 120, height: 15, alignment: .leading)
                                .padding(.top, 10)
                        }
                    }
                    
                    
                    if(objMenuWindowsApi.MenuAndroidUserRolResult.success){
                        HStack{
                            HStack{
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(Color(hex: "#bdbdbf"))
                                    .padding(.leading,10)
                                TextField("Buscar", text: $sBuscar)
                                    .frame(width: 320, height: 40)
                                    .presentationCornerRadius(2.0)
                                
                            }
                            //.background(Color(hex: "#F1f1f1"))
                            .background(.white)
                            .clipShape(Capsule())
                            .padding()
                        }
                        .background(Color(hex: "#f1f1f6"))
                        List(objResults, id: \.self){ventana in
                            let Vista = getMenuView(sViewName: ventana.ViewName)
                            
                            if(Vista.success){
                                
                                NavigationLink(destination: Vista.view){
                                    
                                    Label("\(ventana.DescriptionMenu)", systemImage: "macwindow")
                                   // Image(systemName: "macwindow")
                                        //.background(.white)
                                   //Text("Hola")
                                        
                                        //.foregroundStyle(.white)
                                        
                                }
                                //.listRowBackground(Color.pink)
                            }
                        }
                        //.scrollContentBackground(.hidden)
                        .padding(.top, -25)
                        .navigationTitle("Menu")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                    else{
                        Spacer()
                        HStack(alignment: .center){
                            Spacer()
                            VStack{
                                Text("No hay menus habilitados para este usuario")
                                Image("Triste")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 90)
                                    .padding(80)
                                   
                                
                                    
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            self.bCerrarSesion = true
                        }, label: {
                            Text("Cerrar Sesión")
                            
                                .frame(width: 350, height: 50)
                            
                        })
                        .modifier(btnCancelar())
                        .clipShape(.capsule)
                        
                        Spacer()
                    }
                    .padding(.bottom,-20)
                    
                })
                
            }
        }
        .onAppear(perform: objMenuWindowsApi.getMenuAndroidUserRol)
        .alert(isPresented: $bCerrarSesion){
            Alert(title: Text("Salir"), message: Text("¿Deseas cerrar sesión?"), primaryButton: .default(Text("Si")){
                self.bLogin = false
                UserDefaults.standard.removeObject(forKey: "UserData")
                UserDefaults.standard.removeObject(forKey: "Guardado")
            }, secondaryButton: .cancel(Text("No")))
        }
    }
    
    func getMenuView(sViewName : String) -> stNextView{
        var objNextView = stNextView(success: true, view: AnyView.init(vw_dbo_Login(bLogin: true)) )
        switch sViewName
        {
        case "WIN_wms_Ledger":
            objNextView.view = AnyView.init(WIN_wms_Ledger())
            break
        case "WIN_wms_ItemInventory":
            objNextView.view = AnyView.init(WIN_wms_ItemInventory())
            break
        default:
            objNextView.success = false
        }
        return objNextView
    }
    
    
    
    
    struct stNextView{
        var success : Bool
        var view : AnyView
    }
    
}

#Preview {
    vw_dbo_Sliding(bLogin: .constant(true))
}
