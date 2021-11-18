//
//  BaseViewController.swift
//  BAPMobile
//
//  Created by Emcee on 12/14/20.
//

import UIKit
import SideMenu
import CoreLocation

protocol BlurViewDelegate {
    func hideBlur()
    func showBlur()
}

protocol ImagePickerFinishDelegate {
    func imagePickerFinish(image: UIImage)
}

class BaseViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var imagePickDelegate: ImagePickerFinishDelegate?
    let locationManager = CLLocationManager()
    let blurView = UIView()
    var map = MapData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func updateBadge() {
        var badge = UserDefaults.standard.integer(forKey: "badge")
        badge -= 1
        UIApplication.shared.applicationIconBadgeNumber = badge
        UserDefaults.standard.setValue(badge, forKey: "badge")
    }
    //Setup base view controller
    private func setupView() {
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor().defaultColor()
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.backgroundColor = UIColor().defaultColor()

        let yourBackImage = UIImage(named: "ic_back")?.resizeImage(targetSize: CGSize(width: 20, height: 20))
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationController?.navigationBar.topItem?.title = " "
        
        UNUserNotificationCenter.current().requestAuthorization(options: .badge) { (granted, error) in
            if error != nil {

                // success!
            }
        }
        
        hideKeyboardWhenTappedAround()
        blurScreenWhenNotForgeground()
        blurView.backgroundColor = .black
        blurView.alpha = 0.5
        blurView.frame = view.bounds
        
        getCurrentPlace()
    }
    
    private func blurScreenWhenNotForgeground() {
        let notiToBackground = NotificationCenter.default
        notiToBackground.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        let notiToForgeground = NotificationCenter.default
        notiToForgeground.addObserver(self, selector: #selector(appAppear), name: UIApplication.didBecomeActiveNotification, object: nil)
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
    
    func showKeyboard() {
        //Add Observer detect hide and show keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    func getCurrentLocationParam() -> BASmartLocationParam {
        let location = getCurrentLocation()
        let locationParam = BASmartLocationParam(lng: location.lng,
                                                 lat: location.lat,
                                                 opt: 0)
        
        return locationParam
    }
    
    //Hide and show keyboard
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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
    
    func getCurrentPlace() {
        let current = getCurrentLocation()
        let param = MapSelectParam(latstr: String(current.lat),
                                   lngstr: String(current.lng))
        
        Network.shared.SelectMap(param: param) { [weak self] (data) in
            self?.map = data?.first ?? MapData()
        }
    }
    
    func showBlurBackground() {
        self.view.addSubview(blurView)
    }
    
    func hideBlurBackground() {
        blurView.removeFromSuperview()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 1.5
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
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

extension BaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            self?.imagePickDelegate?.imagePickerFinish(image: image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension BaseViewController: CLLocationManagerDelegate {
    
}

extension BaseViewController: BlurViewDelegate {
    func showBlur() {
    }
    
    func hideBlur() {
        hideBlurBackground()
    }
}
