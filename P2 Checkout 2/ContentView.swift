//
//  ContentView.swift
//  P2 Checkout 2
//
//  Created by Eal on 29.10.23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isScannerPresented = false
    @State private var isSafariPresented = false
    @State private var scannedCode = "no"
    
    var body: some View {
        VStack {
            Button("QR-Code scannen") {
                isScannerPresented.toggle()
            }
            .sheet(isPresented: $isScannerPresented) {
                QRCodeScannerView { code in
                    scannedCode = code
                    isSafariPresented = true
                    isScannerPresented = false
                }
            }
            .sheet(isPresented: $isSafariPresented) {
                SafariView(url: URL(string: "https://example.com/?code=\(scannedCode)")!)
            }
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hels 23, world!")
            Text(scannedCode)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
