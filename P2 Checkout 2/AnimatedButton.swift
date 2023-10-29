//
//  AnimatedButton.swift
//  P2 Checkout 2
//
//  Created by Eal on 29.10.23.
//

import SwiftUI

struct AnimatedButton: View {
    var title: String
    var action: () -> Void

    @GestureState private var isPressed = false

    var body: some View {
        ZStack {
            Color(isPressed ? .gray : .blue)
                .opacity(0.1)
            Text(title)
                .foregroundColor(.blue)
                .font(.headline)
        }
        .cornerRadius(25.0)
        .frame(width: 250, height: 50)
        .scaleEffect(isPressed ? 0.9 : 1)
        .gesture(TapGesture()
            .updating($isPressed) { (value, state, transaction) in
                state = true
            }
            .onEnded { _ in
                withAnimation {
                    self.action()
                }
            }
        )
    }
}


#Preview {
    AnimatedButton(title: "QR-Code scannen") {
        // Taschenlampe einschalten (falls implementiert)
        // isScannerPresented.toggle()
    }
}
