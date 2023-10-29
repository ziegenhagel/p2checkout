import SwiftUI
import WebKit
import AVFoundation

struct ContentView: View {
    
    @State private var isScannerPresented = false
    @State private var scannedCode = ""
    @State private var responseText = ""
    @State private var action: Action = .borrow
    
    enum Action: String, CaseIterable {
        case info = "info"
        case borrow = "ausleihen"
        case returnItem = "zurückgeben"
        
        var icon: String {
            switch self {
            case .info: return "info.circle.fill"
            case .borrow: return "arrow.down.circle.fill"
            case .returnItem: return "arrow.up.circle.fill"
            }
        }
    }
    
    var body: some View {
        VStack {
          
            HStack {
                Picker("", selection: $action) {
                    ForEach(Action.allCases, id: \.self) { action in
                        VStack {
                            Image(systemName: action.icon)
                                .font(.title2)  // Increase the font size here, for example .title2, .title3, etc.
                                .padding(.trailing, 10)  // Increase the gap by adjusting the trailing padding value
                            
                            Text(action.rawValue.capitalized)
                        }.tag(action)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal, 15)
            }
            
            WebView(urlString: "http://192.168.178.92:3000/checkout\(scannedCode.isEmpty ? "" : "/\(action.rawValue)/\(scannedCode)")")
            
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
                        isScannerPresented = false
                    }
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
