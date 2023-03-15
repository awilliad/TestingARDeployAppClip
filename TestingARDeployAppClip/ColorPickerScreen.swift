//
//  ColorPickerScreen.swift
//  TestingARDeployAppClip
//
//  Created by Arie Williams on 3/13/23.
//

import SwiftUI
import AVFoundation

struct ColorPickerScreen: View {
    //@Binding var modelURL: String
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
}

struct DropDownOption: Hashable {
    public static func == (lhs: DropDownOption, rhs: DropDownOption) -> Bool {
        return lhs.key == rhs.key
    }
    
    var key: String
    var val: CGColor
}

struct DropDownOptionElement: View {
    var val: CGColor
    var key: String
    
    var onSelect:((_ key: String) -> Void)?
    
    var body: some View {
        Button(action: {
            if let onSelect = self.onSelect {
                onSelect(self.key)
            }
        }) {
            Color(self.val)
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
    }
}

struct DropDown: View {
    var options: [DropDownOption]
    var onSelect: ((_ key: String ) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(self.options, id: \.self) { option in DropDownOptionElement(val: option.val, key: option.key, onSelect: self.onSelect)
            }
        }
        
        .background(Color.white)
        .cornerRadius(0.5)
        .overlay(
            RoundedRectangle(cornerRadius: 0.5)
                .stroke( lineWidth: 1)
        )
    }
}

struct DropdownMenuView: View {
    @State private var selectedOption = ("Blue", Color.blue)
    @State private var selectedColor: Color = Color.blue
    @State var isShowingScanner = false
    @State var scannedCode: String? = nil
    
    let options = [("Blue", Color.blue), ("Green", Color.green), ("Red", Color.red), ("Orange", Color.orange)]
    
    var body: some View {
        VStack {
            Text("Selected Door Color Option: \(selectedOption.0)")
                .padding()
                .foregroundColor(selectedOption.1)
            
            Menu {
                ForEach(options, id: \.0) { option in
                    Button(action: {
                        self.selectedOption = option
                        self.selectedColor = option.1
                    }) {
                        HStack {
                            Text(option.0)
                            Spacer()
                            Circle()
                                .fill(option.1)
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            } label: {
                Label("Select Option", systemImage: "chevron.down.circle")
                    .padding()
            }
            
            if let code = scannedCode {
                Text("Scanned QR code: \(code)")
            } else {
                Text("Scan a QR code")
            }
            
            Button("Scan QR code") {
                self.isShowingScanner = true
            }
            
            NavigationLink(
                destination: ContentView(frameColor: $selectedColor),
                label: {
                    Text("See in AR")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                })
        }
        .sheet(isPresented: $isShowingScanner) {
            QRCodeScanner(scannedCode: self.$scannedCode)
        }
        .navigationTitle("Home")
    }
}

//struct QRScannerView: View {
//
//    @State var isShowingScanner = false
//    @State var scannedCode: String? = nil
//
//    var body: some View {
//        VStack {
//            if let code = scannedCode {
//                Text("Scanned QR code: \(code)")
//            } else {
//                Text("Scan a QR code")
//            }
//
//            Button("Scan QR code") {
//                self.isShowingScanner = true
//            }
//        }
//        .sheet(isPresented: $isShowingScanner) {
//            QRCodeScanner(scannedCode: self.$scannedCode)
//        }
//    }
//}

struct QRCodeScanner: UIViewControllerRepresentable {
    
    @Binding var scannedCode: String?
    
    func makeUIViewController(context: Context) -> QRScannerViewController {
        return QRScannerViewController(scannedCode: $scannedCode)
    }
    
    func updateUIViewController(_ uiViewController: QRScannerViewController, context: Context) {
        // Do nothing
    }
}

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let session = AVCaptureSession()
    let metadataOutput = AVCaptureMetadataOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var scannedCode: Binding<String?>
    
    init(scannedCode: Binding<String?>) {
        self.scannedCode = scannedCode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the capture session
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get video capture device")
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("Failed to create video input: \(error)")
            return
        }
        
        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        } else {
            print("Failed to add video input to session")
            return
        }
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
        } else {
            print("Failed to add metadata output to session")
            return
        }
        
        metadataOutput.metadataObjectTypes = [.qr]
        
        // Configure the preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // Start the capture session
        session.startRunning()
        
        //End the capture session
        if (scannedCode.wrappedValue == nil) {
            return
        } else {
            viewWillDisappear(true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first else {
            return
        }
        
        guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        guard let stringValue = readableObject.stringValue else {
            return
        }
        
        scannedCode.wrappedValue = stringValue
        
    }
    
}



struct ColorPickerScreenView_Previews : PreviewProvider {
    static var previews: some View {
        DropdownMenuView()
    }
}
