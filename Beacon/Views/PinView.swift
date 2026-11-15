//
//  PinView.swift
//  Beacon

import SwiftUI

struct PinView : View {
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.red.opacity(0.8))
                .frame(width: 50, height: 50)
            
            Image("pinsmall")
                .resizable()
                .frame(width: 50, height: 50)
                .shadow(color: .gray, radius: 5)
            
        }
    }
}
