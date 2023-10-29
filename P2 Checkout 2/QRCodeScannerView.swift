import SwiftUI
import AVFoundation

struct QRCodeScannerView: UIViewControllerRepresentable {
    var handleScannedCode: (String) -> Void

    func makeUIViewController(context: Context) -> QRScannerController {
        let scanner = QRScannerController()
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ uiViewController: QRScannerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    final class Coordinator: NSObject, QRScannerControllerDelegate {
        var parent: QRCodeScannerView

        init(_ parent: QRCodeScannerView) {
            self.parent = parent
        }

        func codeDidScan(_ code: String) {
            parent.handleScannedCode(code)
        }
    }
}
