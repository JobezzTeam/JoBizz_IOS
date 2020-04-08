//
//  ApplicantMapViewController.swift
//  JoBizz
//
//  Created by harold Armijo Leon on 08/12/2019.
//  Copyright © 2019 harold Armijo Leon. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import os.log

extension UIViewController {
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }

}

class ApplicantMapViewController: UIViewController {
    
    //MARK: Properties
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
//    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 17.0
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []

    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    var infoWindowMapClicked: InfoWindowMap?
    
    var makerPositionClient: GMSMarker? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        GMSPlacesClient.provideAPIKey("api key")
        
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6.
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 17.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        view = mapView
//
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

//        placesClient = GMSPlacesClient.shared()
        
        // default location
        let camera = GMSCameraPosition.camera(withLatitude: 48.8566,
                                              longitude: 2.3522,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        //mapView.isMyLocationEnabled = true
        
        // style Google Maps
        setMapStyle()

        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        
        loadJobsAround()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ?? "" {
        case "MapToProposition":
            guard let destination = segue.destination as? OfferViewController
                else { fatalError("Unexpected destination: \(segue.destination)") }
            destination.infoPost = infoWindowMapClicked
            os_log("opening OfferVC.", log: OSLog.default, type: .debug)
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    
    //MARK: Methods
    func loadJobsAround() {
        
        // fake jobs
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(
           latitude: 48.868343, longitude: 2.532712)
//        marker.title = "Crocus café"
//        marker.snippet = "type = restorant\nadresse: 24 rue pasteur, 94100"
        marker.userData = InfoWindowMap(title: "Crocus café", body: "type = restaurant\nadresse: 24 rue pasteur, 94100")
        marker.icon = UIImage(named: "pinInMap")
        marker.map = mapView
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(
           latitude: 48.867366, longitude: 2.538785)
//        marker2.title = "Crocus café"
//        marker2.snippet = "type = restorant\nadresse: 24 rue pasteur, 94100"
        marker2.userData = InfoWindowMap(title: "Crocus café", body: "type = restaurant\nadresse: 24 rue pasteur, 94100", desc: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.\nLorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.\nLorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.\nLorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.")
        marker2.icon = UIImage(named: "pinInMap")
        marker2.map = mapView
        
        if ManagerMongo.connexionIsValid == .Success {
            let coll = ManagerMongo.mongoClient!.db("jobizz").collection("annonces")
            
            coll.find().toArray { (result) -> Void in
                switch result {
                case .success(let result):
                    print("----------")
                    result.forEach { (document) in
                        print(document["desc"] as! String)
                    }
                case .failure(let error):
                    print("error annonces \(error)")
                }
            }
        }
    }
    
    func setMapStyle() -> Void {
        if UIViewController().isDarkMode {
            do {
              // Set the map style by passing the URL of the local file.
              if let styleURL = Bundle.main.url(forResource: "styleGoogleMaps", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
              } else {
                NSLog("Unable to find style.json")
              }
            } catch {
              NSLog("One or more of the map styles failed to load. \(error)")
            }
        } else {
            mapView.mapStyle = nil
        }
    }
    
    
    
    //MARK: Action
    @IBAction func unwindToMapView(sender: UIStoryboardSegue) {
        
        if let src = sender.source as? OfferViewController {
            print("enter in map view from OfferMapViewController")
        }
    }
    
    // When dark mode change
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard UIApplication.shared.applicationState == .inactive else {
            return
        }
        
        setMapStyle()
    }


}


//MARK: CLLocationManagerDelegate (apple methods)
extension ApplicantMapViewController: CLLocationManagerDelegate {

  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")

    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                          longitude: location.coordinate.longitude,
                                          zoom: zoomLevel)

    if mapView.isHidden {
        mapView.isHidden = false
        mapView.camera = camera

    } else {
        mapView.animate(to: camera)
    }
    
    // Creates a marker in the center of the map.
    if makerPositionClient == nil {
        makerPositionClient = GMSMarker()
    }
    makerPositionClient!.position = CLLocationCoordinate2D(
       latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//    marker.title = "Your current location"
//    marker.snippet = "body"
    makerPositionClient!.userData = InfoWindowMap(title: "Your current location", body: "lorem ipsum")
    makerPositionClient!.map = mapView
  }
           
  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
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
    }
  }

  // Handle location manager errors.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    print("Error: \(error)")
  }
}


//MARK: GMSMapViewDelegate
extension ApplicantMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if (marker.userData != nil) && (marker.userData as! InfoWindowMap).title != "Your current location" {
            
            let infoWindow = marker.userData as! InfoWindowMap
            
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "OfferViewController") as! OfferViewController
//            self.present(newViewController, animated: true, completion: nil)
            print(infoWindow.title)
            infoWindowMapClicked = infoWindow
            performSegue(withIdentifier: "MapToProposition", sender: self)
        } else if (marker.userData != nil) && (marker.userData as! InfoWindowMap).title == "Your current location" {
            print("you clicked in your current position")
        } else {
            print("the pin doen't have userData")
        }
    }
    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
//        print("---------------------------------")
//        print(marker.userData ?? "nulllllllll")
//        print("---------------------------------")
        
        if let infoWindow = marker.userData as? InfoWindowMap {
            return self.createInfoWindowMap(title: infoWindow.title, body: infoWindow.body)
        }
        return self.createInfoWindowMap(title: "Hi there!", body: "I am a custom info window.")
    }
    
    func createInfoWindowMap(title: String, body: String) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor(red:0.16, green:0.63, blue:0.88, alpha:1.0)
        view.layer.cornerRadius = 6

        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        lbl1.text = title
        lbl1.numberOfLines = 0;
        lbl1.textColor = .systemBackground
        view.addSubview(lbl1)

        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        lbl2.text = body
        lbl2.numberOfLines = 0;
//        lbl2.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbl2.textColor = .systemBackground
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(lbl2)
        return view
    }
}
