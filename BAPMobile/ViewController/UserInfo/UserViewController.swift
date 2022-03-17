//
//  UserViewController.swift
//  BAPMobile
//
//  Created by Emcee on 12/4/20.
//

import UIKit
import AVFoundation
import Toaster
import Kingfisher

class UserViewController: BaseViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var barcodeView: UIView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var officeLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var data: User?
    var delegate: MainTabBarDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        nameLabel.text = data?.full_name
        cityLabel.text = "Chi nhánh: \(data?.brance_name ?? "")"
        officeLabel.text = "Phòng ban: \(data?.department_name ?? "")"
        phoneLabel.text = "Di động: \(data?.mobile ?? "")"
        emailLabel.text = "Email: \(data?.email ?? "")"
        
        avatarButton.layer.cornerRadius = 0.5 * avatarButton.bounds.size.width
        avatarButton.clipsToBounds = true
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        previewLayer.videoGravity = .resizeAspectFill
        barcodeView.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
    
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            DispatchQueue.global().async { [weak self] in
                self?.captureSession.stopRunning()
            }
        }
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
//        dismiss(animated: true)
    }
    
    func found(code: String) {
        print(code)
        presentBasicAlert(title: code, message: "", buttonTittle: "Done")
    }
    
    @IBAction func logoutButtonTap(_ sender: Any) {
        
        let alert = UIAlertController(title: "Đăng xuất khỏi hệ thống", message: "Bạn có chắc chắn muốn đăng xuất không?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Từ chối", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { [weak self] (action) in
            Network.shared.logout { [weak self] (data) in
                if data?.errorCode == 0 {
                    self?.delegate?.backToLogin()
                } else {
                    self?.presentBasicAlert(title: data?.message ?? "", message: "", buttonTittle: "Đồng ý")
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func avatarButtonTap(_ sender: Any) {
        showAlertSelectImage()
        imagePickDelegate = self
    }
    
}

extension UserViewController: ImagePickerFinishDelegate {
    func imagePickerFinish(image: UIImage) {
        avatarButton.setImage(image.resizeImage(targetSize: CGSize(width: 120, height: 120)), for: .normal)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
