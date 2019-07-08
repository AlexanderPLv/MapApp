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
class MapVC: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate , UIImagePickerControllerDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cameraButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var showImagesButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cameraButton: UIButton!
    
    let picker = UIImagePickerController()
    
    var goingToShowCollectionView = true
    
    var images = [UIImage]()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.sourceType = .photoLibrary
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.userTrackingMode = .follow
        
    }
    
    @IBAction func photoButton(_ sender: Any) {
        present(picker, animated: true)
    }
    
    @IBAction func didTapCurrentLocation(_ sender: UIButton) {
        guard let currentLocation = currentLocation else { return }
        mapView.camera.centerCoordinate = currentLocation.coordinate
    }
    
    @IBAction func didTapToggleImage(_ sender: UIButton) {
        
        if goingToShowCollectionView == true {
            showImagesButton.setTitle("Hide Images", for: .normal)
            
            collectionViewBottomConstraint.constant = 20
            cameraButtonBottomConstraint.constant = -100
            
        } else {
            showImagesButton.setTitle("Show Images", for: .normal)
            
            collectionViewBottomConstraint.constant = -100
            cameraButtonBottomConstraint.constant = 20
        }
        
        UIView.animate(withDuration: 0.3) {
            self.collectionView.alpha = self.goingToShowCollectionView ? 1 : 0
            self.cameraButton.alpha = self.goingToShowCollectionView ? 0 : 1
            
            
            self.view.layoutIfNeeded()
        }
        
        goingToShowCollectionView = !goingToShowCollectionView
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            case .authorizedWhenInUse: manager.startUpdatingLocation()
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        self.currentLocation = currentLocation
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }

        images.append(image)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCell
        
        let image = images[indexPath.item]
        cell.populate(with: image)
        
        return cell
    }
    
}
