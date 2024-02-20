//
//  vw_dbo_Principal.swift
//  NESGo
//
//  Created by Guillermo Alvarez on 09/02/24.
//

import SwiftUI

struct vw_dbo_Principal: View {
    @State var bCerrarSesion : Bool = false
    @Binding var bLogin : Bool
    
    var bgColor: Color = Color(.init(
                                  red: 52 / 255,
                                  green: 70 / 255,
                                  blue: 182 / 255,
                                  alpha: 1))
    
    @State private var isSideBarOpened = false
    
    var body: some View {
        ZStack{
            NavigationView{
                VStack{
                    Text("")
                        .navigationTitle("NESGo Principal")
//                        .toolbar {
//                            Button {
//                                isSideBarOpened.toggle()
//                            } label: {
//                                Label("Toggle SideBar",
//                                      systemImage: "line.3.horizontal.circle.fill")
//                            }
//                        }
//                        .listStyle(.inset)
//                        
                       .navigationBarTitleDisplayMode(.inline)
                    VStack{
                        
                        Text("¡Bienvenido!")
                            .font(.title)
                            .foregroundStyle(Color(hex: "#002D57"))
                            .bold()
                            .padding(.top, 150)
                            
                        
                        Image("NESGO-120")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .aspectRatio(contentMode: .fit)
                        Text("Mobile")
                            .font(.largeTitle)
                            .foregroundStyle(Color(hex: "#002D57"))
                            .bold()
                            .padding(.top, -35)
                            .padding(.leading, 155)
                        Spacer()
                    }
                    .frame(width: 390, height: 650)
                    .background(Color(hex: "#B8dff3"))
                    //.padding(.all)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
//                    Button(action: {
//                        self.bCerrarSesion = true
//                    }, label: {
//                        Text("Este es el bueno")
//                    })
                    
                    
                }
            }
            SideBar(isSidebarVisible: $isSideBarOpened, bLogin: $bLogin)
        }
        
    }
}

#Preview {
    vw_dbo_Principal(bLogin: .constant(true))
}
