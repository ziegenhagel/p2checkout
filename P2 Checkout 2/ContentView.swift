//
//  ContentView.swift
//  P2 Checkout 2
//
//  Created by Eal on 29.10.23.
//

import SwiftUI
import WebKit
import AVFoundation

struct ContentView: View {
    
    @State private var isScannerPresented = false
    @State private var isSafariPresented = false
    @State private var scannedCode = ""
    
    @State private var responseText = ""
    
    
    var body: some View {
        VStack {
            // Ständig angezeigte SafariView von example.com
            
            WebView(urlString: "http://192.168.178.92:3000/checkout/\(scannedCode)")
            
            HStack{
                
                Button(action: {
                       scannedCode = " "
                   }) {
                       Image(systemName: "list.dash")
                           .resizable()
                           .frame(width: 24, height: 24)
                           .padding(.trailing, 10)
                   }

                AnimatedButton(title: "QR-Code scannen") {
                    //turnOnTorch()
                    isScannerPresented.toggle()
                }
                .sheet(isPresented: $isScannerPresented, onDismiss: {
                    // turnOffTorch()
                }) {
                    QRCodeScannerView { code in
                        scannedCode = code
                        isSafariPresented = true
                        isScannerPresented = false
                    }
                }
            }
            
            /*
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
             */
            
        }
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

/*
func turnOnTorch() {
    guard let device = AVCaptureDevice.default(for: .video) else { return
        print("Torch is not available on this device.")
    }
    if device.hasTorch {
        do {
            try device.lockForConfiguration()
            device.torchMode = .on
            try device.setTorchModeOn(level: 1) // Niedrigste Stufe .1
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    } else {
        print("Torch is not available")
    }
}

func turnOffTorch() {
    guard let device = AVCaptureDevice.default(for: .video) else { return
        print("Torch is not available on this device.")
    }
    if device.hasTorch {
        do {
            try device.lockForConfiguration()
            device.torchMode = .off
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    }
}

**/
