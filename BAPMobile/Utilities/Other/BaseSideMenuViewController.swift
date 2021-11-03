//
//  BaseSideMenuViewController.swift
//  BAPMobile
//
//  Created by Emcee on 12/24/20.
//

import UIKit
import SideMenu
import CoreLocation
import Photos

class BaseSideMenuViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var imagePickerDelegate: ImagePickerFinishDelegate?
    let locationManager = CLLocationManager()
    var locValue = CLLocationCoordinate2D()
    var pickedImage = UIImage()
    var isFromBase = false
    let blurView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSideMenu()
        setupView()
        requestPhoto()
        blurScreenWhenNotForgeground()
    }
    
    //Setup base view controller
    private func setupView() {
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor().defaultColor()
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        hideKeyboardWhenTappedAround()
        
        locationManager.delegate = self
        getLocationPermission()
        
        blurView.backgroundColor = .black
        blurView.alpha = 0.5
        blurView.frame = view.bounds
    }
    
    private func requestPhoto() {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    
                } else {}
            })
        }
    }
    
    private func uploadDailyWorkingPhoto(image: UIImage) {
        isFromBase = false
        let photo = BASmartDailyWorkingPhotolist(image: image.toBase64() ?? "",
                                                 time: Int(Date().timeIntervalSinceReferenceDate))
        var photoList = [BASmartDailyWorkingPhotolist]()
        photoList.append(photo)
        let param = BASmartDailyWorkingParam(photolist: photoList)
        Network.shared.BASmartDailyWorkingPhoto(param: param) { (item) in
            
        }
    }
    
    //Hide and show keyboard
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func blurScreenWhenNotForgeground() {
        let notiToBackground = NotificationCenter.default
        notiToBackground.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        let notiToForgeground = NotificationCenter.default
        notiToForgeground.addObserver(self, selector: #selector(appAppear), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func showBlurBackground() {
        self.view.addSubview(blurView)
    }
    
    func hideBlurBackground() {
        blurView.removeFromSuperview()
    }
    
    func getLocationPermission() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func getCurrentLocation() -> MapLocation {
        var current = MapLocation(lng: 0, lat: 0)
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locationManager.location else {
                return MapLocation(lng: 0, lat: 0)
            }
            
            current = MapLocation(lng: currentLocation.coordinate.longitude,
                                  lat: currentLocation.coordinate.latitude)
        }
        return current
        
    }
    
    func hideLeftBarButton() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back")?.resizeImage(targetSize: CGSize(width: 20, height: 20)), style: .plain, target: self, action: #selector(backButtonAction))
    }
    
    func showLeftBarButton() {
        self.navigationItem.leftBarButtonItem = nil
        addSideMenu()
    }
    
    func showListPhoneNumber(objectId: Int, kindId: Int) {
        Network.shared.BASmartGetPhoneNumber(kindId: kindId, objectId: objectId) { [weak self] (data) in
            let phoneList = data?.map({ ($0.phone ?? "") }) ?? [String]()
            if phoneList.count > 0 {
                self?.getListPhone(phones: phoneList)
            }
        }
    }
    
    func getListPhone(phones: [String]) {
        let storyBoard = UIStoryboard(name: "BASmart", bundle: nil)
        let popoverContent = storyBoard.instantiateViewController(withIdentifier: "BASmartShowPhoneNumberViewController") as! BASmartShowPhoneNumberViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 200, height: 40 * phones.count - 39)
        popoverContent.phones = phones
        popoverContent.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        popover?.delegate = self
        showBlurBackground()
        self.present(nav, animated: true, completion: nil)
    }
    
    func getCatalog() {
        Network.shared.BASmartGetCustomerCatalog { (data) in
            BASmartCustomerCatalogDetail.shared.setBASmartCustomerCatalog(
                customerKind: data?.customer_kind ?? [BASmartCustomerCatalogItems](),
                ethnic: data?.ethnic ?? [BASmartCustomerCatalogItems](),
                gender: data?.gender ?? [BASmartCustomerCatalogItems](),
                humanKind: data?.human_kind ?? [BASmartCustomerCatalogItems](),
                leaveLevel: data?.leave_level ?? [BASmartCustomerCatalogItems](),
                marital: data?.marital ?? [BASmartCustomerCatalogItems](),
                model: data?.model ?? [BASmartCustomerCatalogItems](),
                position: data?.position ?? [BASmartCustomerCatalogItems](),
                provider: data?.provider ?? [BASmartCustomerCatalogItems](),
                purpose: data?.purpose ?? [BASmartCustomerCatalogItems](),
                region: data?.region ?? [BASmartCustomerCatalogItems](),
                religion: data?.religion ?? [BASmartCustomerCatalogItems](),
                scale: data?.scale ?? [BASmartCustomerCatalogItems](),
                side: data?.side ?? [BASmartCustomerCatalogItems](),
                source: data?.source ?? [BASmartCustomerCatalogItems](),
                state: data?.state ?? [BASmartCustomerCatalogItems](),
                transport: data?.transport ?? [BASmartCustomerCatalogItems](),
                type: data?.type ?? [BASmartCustomerCatalogItems](),
                rate: data?.rate ?? [BASmartCustomerCatalogItems](),
                reason: data?.reason ?? [BASmartCustomerCatalogItems](),
                project: data?.project ?? [BASmartCustomerCatalogItems](),
                ability: data?.ability ?? [BASmartCustomerCatalogItems](),
                department: data?.department ?? [BASmartCustomerCatalogItems](),
                humanProf: data?.humanProf ??  [BASmartCustomerCatalogItemsDetail]() )
        }
    }
    
    @objc func backButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //Setup Side menu
    @objc func openSideMenu() {
        let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        let menu = SideMenuNavigationController(rootViewController: vc)
        menu.leftSide = true
        menu.menuWidth = 0.8 * view.frame.width
        menu.pushStyle = .replace
        present(menu, animated: true, completion: nil)
    }
    
    @objc func close() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func checkoutBASmart() {
        let storyBoard = UIStoryboard(name: "BASmart", bundle: nil)
        let popoverContent = storyBoard.instantiateViewController(withIdentifier: "BASmartCheckoutViewController") as! BASmartCheckoutViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize(width: 300, height: 150)
        popoverContent.location = MapLocation(lng: locValue.longitude, lat: locValue.latitude)
        popoverContent.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY,width: 0,height: 0)
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        popover?.delegate = self
        showBlurBackground()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.present(nav, animated: true, completion: nil)
        }
    }
    
    @objc func appAppear() {
        view.removeBlurLoader()
    }
    
    @objc func appMovedToBackground() {
        view.showBlurLoader()
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        hideBlurBackground()
    }
}

extension BaseSideMenuViewController {
    func addSideMenu() {
        let vc = UIStoryboard(name: "BASmart", bundle: nil).instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        let leftMenu = SideMenuNavigationController(rootViewController: vc)
        leftMenu.menuWidth = 0.8 * view.frame.width
        leftMenu.pushStyle = .replace
        SideMenuManager.default.leftMenuNavigationController = leftMenu
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController?.navigationBar ?? UINavigationBar())
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController?.view ?? UINavigationBar())
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "list")?.resizeImage(targetSize: CGSize(width: 15, height: 15)), style: .plain, target: self, action: #selector(openSideMenu))
        NotificationCenter.default.addObserver(self, selector: #selector(close), name: NSNotification.Name(rawValue: "CloseBASmart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkoutBASmart), name: NSNotification.Name(rawValue: "CheckoutBASmart"), object: nil)
    }
}


extension BaseSideMenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showAlertSelectImage() {
        let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //MARK:- UIImagePickerViewDelegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true) { [weak self] in
            
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            self?.imagePickerDelegate?.imagePickerFinish(image: image)
            
            if self?.isFromBase == true {
                self?.uploadDailyWorkingPhoto(image: image)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension BaseSideMenuViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location?.coordinate ?? CLLocationCoordinate2D()
    }
}

extension BaseSideMenuViewController: BlurViewDelegate {
    func showBlur() {
    }
    
    func hideBlur() {
        hideBlurBackground()
    }
}
