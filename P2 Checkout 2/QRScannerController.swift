import UIKit
import AVFoundation

protocol QRScannerControllerDelegate: AnyObject {
    func codeDidScan(_ code: String)
}

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    weak var delegate: QRScannerControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()
        
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        // Delay the torch activation by 0.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.toggleTorch(on: true) // This will attempt to turn on the torch after a delay
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        toggleTorch(on: false) // Turn off the torch
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if let stringValue = metadataObject.stringValue {
                delegate?.codeDidScan(stringValue)
            }
        }
        
        dismiss(animated: true)
        
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            print("Torch isn't available on this device")
            return
        }
        
        do {
            try device.lockForConfiguration()
            
            if on {
                try device.setTorchModeOn(level: 0.1) //AVCaptureDevice.maxAvailableTorchLevel)
            } else {
                device.torchMode = .off
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    }

}
