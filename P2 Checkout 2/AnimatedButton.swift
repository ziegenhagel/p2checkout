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
            Text(title)
                .foregroundColor(.white)
                .font(.headline)
        }
        .cornerRadius(63.0)
        .frame(width: 250, height: 50)
        .scaleEffect(isPressed ? 0.9 : 1)
        .padding()
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
