//
//  MapViewController.swift
//  BAPMobile
//
//  Created by Emcee on 2/17/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import DropDown

protocol MapSelectDelegate {
    func selectMap(data: [MapData])
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonAccept: UIButton!
    @IBOutlet weak var labelLocationName: UILabel!
    @IBOutlet weak var currentLocationView: UIView!
    
    var locationManager: CLLocationManager!
    var placesClient: GMSPlacesClient!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    var selectedPlace: GMSPlace?
    var isPopover = false
    
    var searchData = [MapData]()
    let dropDown = DropDown()
    var currentLocation: MapLocation?
    var delegate: MapSelectDelegate?
    var blurDelegate: BlurViewDelegate?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        blurDelegate?.hideBlur()
    }
    
    private func setupView() {
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor().defaultColor()
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.setHidesBackButton(true, animated: true)

        self.navigationController?.navigationBar.topItem?.title = " "
        self.title = "CHỌN VỊ TRÍ TRÊN BẢN ĐỒ" 
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        dropDown.anchorView = searchBar
        dropDown.width = searchBar.frame.size.width - 40
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        buttonCancel.layer.borderWidth = 1
        buttonCancel.layer.borderColor = UIColor(hexString: "B4B4B4", alpha: 0.5).cgColor
        buttonCancel.setViewCorner(radius: 10)
        buttonAccept.setViewCorner(radius: 10)
        
        searchBar.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(getCurrentPlace),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    private func searchMap(keys: String, lng: Double, lat: Double) {
        searchData = [MapData]()
        let location = MapLocation(lng: 0,
                                   lat: 0)
        
        let param = MapSearchParam(keys: keys,
                                   size: 5,
                                   distance: 1,
                                   location: location)
        Network.shared.SearchMap(param: param) { [weak self] (data) in
            self?.searchData = data ?? [MapData]()
            self?.dropDown.dataSource = data?.map({($0.name ?? "") + "\n" + ($0.address ?? "")}) ?? [String]()
            self?.dropDown.show()
            self?.dropDown.selectionAction = { [weak self] (index: Int, item: String) in
                let location = self?.searchData[index].coords?.first
                self?.currentLocation = location
                self?.labelLocationName.text = self?.searchData[index].name
                let camera = GMSCameraPosition.camera(withLatitude: location?.lat ?? 0,
                                                      longitude: location?.lng ?? 0,
                                                      zoom: 16)
                self?.mapView.camera = camera
                self?.mapView.animate(to: camera)
                self?.view.endEditing(true)
            }
        }
    }
    
    @objc func getCurrentPlace() {
        let param = MapSelectParam(latstr: String(mapView.camera.target.latitude),
                                   lngstr: String(mapView.camera.target.longitude))
        Network.shared.SelectMap(param: param) { [weak self] (data) in
            self?.labelLocationName.text = data?.first?.address
        }
    }
    
    @IBAction func buttonCurrentLocationTap(_ sender: Any) {
        
    }
    
    @IBAction func buttonCancelTap(_ sender: Any) {
        if isPopover {
            blurDelegate?.hideBlur()
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func buttonAcceptTap(_ sender: Any) {
        let param = MapSelectParam(latstr: String(mapView.camera.target.latitude),
                                   lngstr: String(mapView.camera.target.longitude))
        
        Network.shared.SelectMap(param: param) { [weak self] (data) in
            self?.delegate?.selectMap(data: data ?? [MapData]())
            if self?.isPopover != true {
                _ = self?.navigationController?.popViewController(animated: true)
            } else {
                self?.blurDelegate?.hideBlur()
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check accuracy authorization
        if #available(iOS 14.0, *) {
            let accuracy = manager.accuracyAuthorization
            switch accuracy {
            case .fullAccuracy:
                print("Location accuracy is precise.")
            case .reducedAccuracy:
                print("Location accuracy is not precise.")
            @unknown default:
                fatalError()
            }
        } else {
        }
        
        // Handle authorization status
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        
        self.mapView?.animate(to: camera)
        //Finally stop updating location otherwise it will come again and again in this delegate
        currentLocation = MapLocation(lng: Double(location?.coordinate.longitude ?? 0), lat: Double(location?.coordinate.latitude ?? 0))
        self.locationManager.stopUpdatingLocation()
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
    }

    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            print("nothing to search")
            return
        }
        
        searchMap(keys: query,
                  lng: Double(currentLocation?.lng ?? 0),
                  lat: Double(currentLocation?.lat ?? 0))
    }
}
