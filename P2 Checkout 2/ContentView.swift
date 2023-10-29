//
//  ContentView.swift
//  P2 Checkout 2
//
//  Created by Eal on 29.10.23.
//

import SwiftUI
import WebKit

struct ContentView: View {
    
    @State private var isScannerPresented = false
    @State private var isSafariPresented = false
    @State private var scannedCode = "no"
    
    @State private var responseText = ""
    @State private var safariKey = UUID()
    
    
    var body: some View {
        VStack {
            // Ständig angezeigte SafariView von example.com
            
            WebView(urlString: "https://example.com/?code=\(scannedCode)")
            
            
            Button("QR-Code scannen") {
                isScannerPresented.toggle()
            }
            .sheet(isPresented: $isScannerPresented) {
                QRCodeScannerView { code in
                    scannedCode = code
                    
                    safariKey = UUID()  // This forces a refresh of the SafariView
                    
                    isSafariPresented = true
                    isScannerPresented = false
                }
            }
            .sheet(isPresented: $isSafariPresented) {
                WebView(urlString: "https://example.com/?code=\(scannedCode)")
            }
            
            
            VStack {
                Button("Send POST Request") {
                    // Beispiel-URL und -Body
                    let url = URL(string: "https://example.com/post-endpoint")!
                    let body: [String: Any] = ["key": "value"]
                    
                    performPostRequest(url: url, body: body) { result in
                        switch result {
                        case .success(let response):
                            responseText = response
                        case .failure(let error):
                            responseText = "Error: \(error.localizedDescription)"
                        }
                    }
                }
                
                Text(responseText)
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



func performPostRequest(url: URL, body: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        if let data = data, let string = String(data: data, encoding: .utf8) {
            completion(.success(string))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
        }
    }.resume()
}
