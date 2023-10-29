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
            case .borrow: return "arrow.right.circle.fill"
            case .returnItem: return "arrow.left.circle.fill"
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
                                .frame(minWidth: 30)  // Adjust this value to increase the gap
                            Text(action.rawValue.capitalized)
                        }.tag(action)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal, 10)
                .onChange(of: action) {
                    scannedCode = ""
                }
            }
            
            WebView(urlString: "http://192.168.178.92:3000/checkout\(scannedCode.isEmpty ? "" : "/\(action.rawValue)/\(scannedCode)")")
            
            HStack{
                
                Button(action: {
                    scannedCode = ""
                }) {
                    Image(systemName: "list.dash")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding(.trailing, 15)
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
