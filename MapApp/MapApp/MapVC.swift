//
//  MapVC.swift
//  MapApp
//
//  Created by MacMini on 03/07/2019.
//  Copyright © 2019 com.blablabla. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class MapVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.userTrackingMode = .follow
        
    }
    
    @IBAction func photoButton(_ sender: Any) {
        print("select picture")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .authorizedWhenInUse: manager.startUpdatingLocation()
        default: break
            
        }
        
    }
    
}
