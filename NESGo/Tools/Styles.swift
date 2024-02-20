//
//  Estilos.swift
//  NESGo
//
//  Created by Guillermo Alvarez on 08/02/24.
//
import SwiftUI

struct btnClaro : ViewModifier {
    func body(content: Content) -> some View {
        content
            
            .background(Color(hex: "#a5c3e3"))
            .foregroundColor(Color.white)
            .cornerRadius(20)
    }
}

struct btnCancelar : ViewModifier {
    func body(content: Content) -> some View {
        content
           
            .background(.red)
            .foregroundColor(Color.white)
            .cornerRadius(20)
    }
}

struct btnNice : ViewModifier {
    func body(content: Content) -> some View {
        content
            
            .background(Color(hex: "#002D57"))
            .foregroundColor(Color.white)
            .cornerRadius(20)
    }
}

struct btnColor : ViewModifier {
     var cColor : Color
    func body(content: Content) -> some View {
        content
           
            .background(cColor)
            .foregroundColor(Color.white)
            .cornerRadius(20)
    }
}
