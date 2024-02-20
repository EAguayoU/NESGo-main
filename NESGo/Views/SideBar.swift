//
//  SideView.swift
//  NESGo
//
//  Created by Erik Aguayo on 19/02/24.
//

import SwiftUI

struct SideBar: View {
   
    
    //Controles Sidebar
    @Binding var isSidebarVisible: Bool
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.9
    //var bgColor: Color = Color(hex: "#a5c3e3")
    var bgColor: Color = Color(.white)
    var cColorNice: Color = Color(hex: "#002D57")
    //Barra busqueda
    @State var sBuscar : String = ""
    var objResults : [stMenu]{
        sBuscar.isEmpty ? objMenuWindowsApi.MenuAndroidUserRolResult.data : objMenuWindowsApi.MenuAndroidUserRolResult.data.filter { $0.DescriptionMenu.localizedCaseInsensitiveContains(sBuscar) }
    }
    //Variables sesion
    @State var bCerrarSesion : Bool = false
    @Binding var bLogin : Bool
    //Variables Menu Api
    @ObservedObject var objMenuWindowsApi = clMenuAndroidUserRol(WindowName: "vw_dbo_Sliding")
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(.black.opacity(0.6))
            .opacity(isSidebarVisible ? 1 : 0)
            .animation(.easeInOut.delay(0.2), value: isSidebarVisible)
            .onTapGesture {
                isSidebarVisible.toggle()
            }
            content
        }
        .edgesIgnoringSafeArea(.all)
    }
    //Contenido de la Barra lateral
    var content: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .top) {
                bgColor
                MenuChevron
                
                VStack(alignment: .leading, spacing: 20) {
                    userProfile
                    Divider()
                    if(objMenuWindowsApi.MenuAndroidUserRolResult.success){
                        
                        HStack{
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(Color(hex: "#bdbdbf"))
                                .padding(.leading,10)
                            TextField("Buscar", text: $sBuscar)
                                .frame(width: 250, height: 40)
                                .presentationCornerRadius(2.0)
                            
                        }
                        .background(Color(hex: "#F1f1f1"))
                        .clipShape(Capsule())
                        .padding(.top, -20)
                        .padding()
                        
                        List(objResults, id: \.self){ventana in
                            let Vista = getMenuView(sViewName: ventana.ViewName)
                            
                            if(Vista.success){
                                
                                NavigationLink(destination: Vista.view
                                    .navigationBarBackButtonHidden(true)
                                    .navigationTitle("\(ventana.DescriptionMenu)")
                                    .toolbarBackground(cColorNice, for: .navigationBar)
                                    .toolbarBackground(.visible, for: .navigationBar)){
                                        
                                        Image(systemName: "macwindow")
                                            .foregroundStyle(cColorNice)
                                        Text(ventana.DescriptionMenu)
                                            .foregroundStyle(cColorNice)
                                        
                                    }
                                    .frame(height:30)
                                    .foregroundStyle(cColorNice)
                                // .navigationBarBackButtonHidden(true)
                                //.listRowBackground(.white)
                                
                            }
                            
                        }
                        .background(.white)
                        .padding(.top, -30)
                        //.padding(.leading, -20)
                        //.frame(width: 210, height: 80)
                        .scrollContentBackground(.hidden)
                    }
                    else{
                        Spacer()
                        HStack(alignment: .center){
                            Spacer()
                            VStack{
                                Text("No hay menus habilitados para este usuario")
                                    .foregroundStyle(.white)
                                Image("Triste")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 90)
                                    .padding(80)
                                    .foregroundStyle(.white)
                                   
                                
                                    
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
                            
                                .frame(width: 260, height: 50)
                            
                        })
                        .modifier(btnNice())
                        .foregroundStyle(.white)
                        .clipShape(.capsule)
                        
                        Spacer()
                    }
                    .padding(.bottom, 10)
                }
                .padding(.top, 80)
                .padding(.horizontal, 10)
            }
            .frame(width: sideBarWidth)
            .offset(x: isSidebarVisible ? 0 : -sideBarWidth)
            .animation(.default, value: isSidebarVisible)
            
            
            Spacer()
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
    
    
    
    
    var MenuChevron: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(.white)
                .frame(width: 60, height: 60)
                .rotationEffect(Angle(degrees: 45))
                .offset(x: isSidebarVisible ? -18 : -10)
                .onTapGesture {
                    isSidebarVisible.toggle()
                }
            
            Image(systemName: "chevron.right")
                .foregroundStyle(cColorNice)
                .rotationEffect(
                    isSidebarVisible ?
                    Angle(degrees: 180) : Angle(degrees: 0))
                .offset(x: isSidebarVisible ? -4 : 8)
                
                
        }
        .offset(x: sideBarWidth / 2, y: 50)
        .animation(.default, value: isSidebarVisible)
    }
    
    var userProfile: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("Usuario")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(Color(hex: "#002D57"), lineWidth: 2)
                    }
                
                VStack(alignment: .leading, spacing: 4) {
                    let sUsuario = objMenuWindowsApi.objDataUserResult.FirstName
                    let sApellido = objMenuWindowsApi.objDataUserResult.LastName
                    Text("\(sUsuario.components(separatedBy: " ").first!) ")
                        .foregroundColor(cColorNice)
                        .bold()
                        .font(.custom("Nombre", size: 20))
                    Text("\(sApellido.components(separatedBy: " ").first!)")
                        .foregroundColor(cColorNice)
                        .bold()
                        .font(.custom("Apellido", size: 15))
                    Text(verbatim: objMenuWindowsApi.objDataUserResult.Rol)
                        .foregroundColor(cColorNice)
                        .font(.caption)
                }
                .padding(.leading, 20)
            }
            .padding(.bottom, 20)
            .padding(.leading, 20)
        }
    }
    
    struct stNextView{
        var success : Bool
        var view : AnyView
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
    
}

#Preview {
    SideBar(isSidebarVisible: .constant(false),
            bLogin: .constant(false))
}
