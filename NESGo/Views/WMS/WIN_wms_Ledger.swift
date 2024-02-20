//
//  WIN_wms_Ledger.swift
//  NESGo
//
//  Created by Guillermo Alvarez on 15/02/24.
//

import SwiftUI

struct WIN_wms_Ledger: View {
    //Variable Alerta
    @State private var bAlert = false
    @State private var sMessageAlert = ""
    //Variables Controles
    @State private var dFechaInicio : Date = Date.now
    @State private var dFechaFin : Date = Date.now
    @State var sDocumento : String = ""
    @State var sIdNice : String = ""
    @State var nWarehouse : Int = 0
    @State var nMovementType : Int = 0
    @State var nCantidad : Int = 0
    @State var nCantidadInicial : Int = 0
    @State var nCantidadFinal : Int = 0
    
    //Variables de APis
    @ObservedObject var objLedgerApi = clLedger(WindowName: "WIN_wms_Ledger")
    @ObservedObject var objWarehouse = clWarehouse(WindowName: "WIN_wms_Ledger")
    @ObservedObject var objMovementType = clMovementType(WindowName: "WIN_wms_Ledger")
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            
            HStack{
                Text("Inicio")
                    .foregroundStyle(Color(hex: "#002D57"))
                DatePicker(selection: $dFechaInicio, in: ...Date.now, displayedComponents: .date){}
                    

                Text("Final")
                    .foregroundStyle(Color(hex: "#002D57"))
                DatePicker(selection: $dFechaFin, in: ...Date.now, displayedComponents: .date){}
                    
            }
            .frame(width: 180, height: 40, alignment: .leading)
            
            HStack{
                Text("CEDIS")
                    .foregroundStyle(Color(hex: "#002D57"))
                    .frame(width:130,alignment: .leading)
                Picker("CEDIS", selection: $nWarehouse){
                    Text("<Seleccione...>").tag(0)
                    if(objWarehouse.WarehouseResult.success){
                        ForEach(objWarehouse.WarehouseResult.data, id: \.self){warehouse in
                            Text(warehouse.WarehouseDescription).tag(warehouse.WarehouseID)
                        }
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
                .tint(.black)
            }
            HStack{
                Text("Tipo Movimiento")
                    .foregroundStyle(Color(hex: "#002D57"))
                    .frame(width:130, alignment: .leading)
                Picker("Tipo Movimiento", selection: $nMovementType){
                    Text("<Seleccione...>").tag(0)
                    if(objMovementType.MovementTypeResult.success){
                        ForEach(objMovementType.MovementTypeResult.data, id: \.self){movementType in
                            Text(movementType.MovementType).tag(movementType.MovementTypeID)
                        }
                    }
                    
                    
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
                .tint(.black)
            }
            HStack{
                Text("Documento")
                    .foregroundStyle(Color(hex: "#002D57"))
                TextField("Documento", text: $sDocumento)
                Text("Id Nice")
                    .foregroundStyle(Color(hex: "#002D57"))
                TextField("IdNice", text: $sIdNice)
                    .keyboardType(.numberPad)
            }
            .frame(width: 360)
            
            List(objLedgerApi.LedgerResult.data, id: \.self){kardex in
                if(objLedgerApi.LedgerResult.success){
                    VStack(alignment: .leading, spacing: 15){
                        HStack(alignment: .center){
                            Text(kardex.ItemSecondCode)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(width: 100, alignment: .leading)
 
                            Text(kardex.TransactionDate.prefix(10))
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(width: 100, alignment: .leading)
                            Text(kardex.TransactionTime.prefix(5))
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(width: 100, alignment: .trailing)
                            
                        }
                        .frame(width: 374)
                        
                        HStack(alignment: .center){
                            Text("Movimiento")
                                .foregroundStyle(Color(hex: "#002D57"))
                            Text(kardex.MovementType)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(width: 374, alignment: .leading)
                        HStack{
                            Text("Documento")
                                .foregroundStyle(Color(hex: "#002D57"))
                            Text(kardex.Document)
                                .fixedSize(horizontal: false, vertical: true)
                            Text("Ubicacion")
                                .foregroundStyle(Color(hex: "#002D57"))
                            Text(kardex.Location)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(width: 374, alignment: .leading)
                        HStack(alignment: .center){
                            Text("Nota")
                                .foregroundStyle(Color(hex: "#002D57"))
                            Text(kardex.Note)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(width: 374, alignment: .leading)
                        //.background(.gray)
                        HStack(alignment: .center){
                            Text("Usuario")
                                .foregroundStyle(Color(hex: "#002D57"))
                            Text(kardex.UserName)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(width: 374, alignment: .leading)
                        HStack(alignment: .center){
                            Text("Cantidad")
                                .foregroundStyle(Color(hex: "#002D57"))
                            Text("\(kardex.Quantity)")
                                .frame(width: 50, alignment: .leading)
                            
                            Text("Inv Inicial")
                                .foregroundStyle(Color(hex: "#002D57"))
                            Text("\(kardex.InitialInventory)")
                                .frame(width: 50, alignment: .leading)
                           
                            Text("Inv Final")
                                .foregroundStyle(Color(hex: "#002D57"))
                            Text("\(kardex.FinalInventory)")
                          
                        }
                        .frame(width: 374, alignment: .leading)
                        .frame(maxWidth: .infinity)
                        Divider()
                            .frame(height: 2)
                            .overlay(Color(hex: "#002D57"))
                       
                        // nCantidad += kardex.Quantity
                        // nCantidadInicial += kardex.InitialInventory
                        // nCantidadFinal += kardex.FinalInventory
                    }
                    .padding(.leading,2)
                }
            }
            
            .padding(.leading, -20)
            .frame(width: 390)
            //.scrollContentBackground(.hidden)
            
            Spacer()
            HStack{
                Text("Total")
                    .foregroundStyle(Color(hex: "#002D57"))
                    .frame(width: 70, alignment: .leading)
                Text(String("\(self.objLedgerApi.LedgerResult.data.map{$0.Quantity}.reduce(0, +))"))
                    .frame(width: 125, alignment: .leading)
                Text(String("\(self.objLedgerApi.LedgerResult.data.map{$0.InitialInventory}.reduce(0, +))"))
                    .frame(width: 10, alignment: .leading)
                Text(String("\(self.objLedgerApi.LedgerResult.data.map{$0.FinalInventory}.reduce(0, +))"))
                    .frame(width: 115, alignment: .trailing)
            }
            .frame(width: 374, alignment: .leading)
            HStack{
                Text("Registros")
                    .foregroundStyle(Color(hex: "#002D57"))
                Text("\(objLedgerApi.LedgerResult.data.count)")
            }
        }
        .onAppear(perform:{
            objWarehouse.getWarehouse(objWarehouse: stWarehouseRequest(IsActive:true))
        })
        .padding(.all)
        .padding(.leading,20)
        Spacer()
        HStack(alignment: .bottom){
            
            Button(action: {
                //crea formato fecha "20 feb 2024"
                //var sFecha = dFechaInicio.formatted(.dateTime.year().month().day())
                if(nWarehouse == 0){
                    bAlert = true
                    sMessageAlert = "Seleccione un CEDIS para continuar"
                }else if(nMovementType == 0){
                    bAlert = true
                    sMessageAlert = "Seleccione un Movimiento para continuar"
                }else{
                    bAlert = false
                    let sFechaInicio = dFechaInicio.debugDescription.replacingOccurrences(of: "-", with: "").prefix(8)
                    let sFechaFin = dFechaFin.debugDescription.replacingOccurrences(of: "-", with: "").prefix(8)
                    if(sDocumento != ""){
                        objLedgerApi.getLedger(objLedger: stLedgerRequest(Document:sDocumento, StartDate: String(sFechaInicio), EndDate: String(sFechaFin), MovementTypeID: nMovementType, WarehouseID: nWarehouse))
                    }else if(sIdNice != ""){
                        objLedgerApi.getLedger(objLedger: stLedgerRequest(StartDate: String(sFechaInicio), EndDate: String(sFechaFin), MovementTypeID: nMovementType,ItemSecondCode: sIdNice, WarehouseID: nWarehouse))
                    }else if(sDocumento != "" && sIdNice != ""){
                        objLedgerApi.getLedger(objLedger: stLedgerRequest(Document:sDocumento, StartDate: String(sFechaInicio), EndDate: String(sFechaFin), MovementTypeID: nMovementType,ItemSecondCode: sIdNice, WarehouseID: nWarehouse))
                    }else{
                        objLedgerApi.getLedger(objLedger: stLedgerRequest(StartDate: String(sFechaInicio), EndDate: String(sFechaFin), MovementTypeID: nMovementType,WarehouseID: nWarehouse))
                    }
                }
                
                print(nWarehouse)
                print(nMovementType)
            }, label: {
                Text("Actualizar")
                
                    .frame(width: 410, height: 50, alignment: .center)
                
                Image(systemName: "arrow.counterclockwise")
                    .padding(.leading, -150)
                
                    
            })
            .alert(isPresented: $bAlert){
                Alert(title: Text("Datos Incompletos"),
                    message: Text(sMessageAlert),
                    dismissButton: Alert.Button.default(
                        Text("Ok")
                    )
                )
                
            }
            .modifier(btnNice())
        }
        .onAppear(perform:{
            objMovementType.getMovementType()
        })
        .background(.gray)
        .padding(.bottom, -34)
    }
}

#Preview {
    WIN_wms_Ledger()
}
