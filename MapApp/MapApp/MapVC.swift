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
import Cluster
class MapVC: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate , UIImagePickerControllerDelegate, UICollectionViewDataSource, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cameraButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var showImagesButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cameraButton: UIButton!
    
    let picker = UIImagePickerController()
    let clusterManager = ClusterManager()
    
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
    
    func addAnnotation(with image: UIImage) {
        guard let currentLocationCoordinate = currentLocation else { return }
        let annotation = PhotoAnnotation(image: image)
        annotation.coordinate = currentLocationCoordinate.coordinate
        clusterManager.add(annotation)
        
        clusterManager.reload(mapView: mapView)
    }
    
    // MARK: - Location Manager Delegate
    
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
    
    // MARK: - Image Picker Controller Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        addAnnotation(with: image)
        images.append(image)
        collectionView.reloadData()
    }
    
    // MARK: - Collection View Data Source Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCell
        
        let image = images[indexPath.item]
        cell.populate(with: image)
        
        return cell
    }
    
    // MARK: - Map View Delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let clusterAnnotation = annotation as? ClusterAnnotation {
            let identifier = "Cluster"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if let clusterAnnotationView = view as? ClusterAnnotationView {
                
                clusterAnnotationView.annotation = clusterAnnotation
                clusterAnnotationView.countLabel.text = String(clusterAnnotation.annotations.count)
                
            } else {
                let clusterAnnotationView = StyledClusterAnnotationView(annotation: clusterAnnotation,
                                                                        reuseIdentifier: identifier,
                                                                        style: .color(.green, radius: 25))
                view = clusterAnnotationView
            }
            return view
            
        } else if let photoAnnotation = annotation as? PhotoAnnotation {
            
            let identifier = "Photo"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if let annotationView = view {
                
                annotationView.annotation = photoAnnotation
                
            } else {
                
                let annotationView = MKAnnotationView(annotation: photoAnnotation, reuseIdentifier: identifier)
                view = annotationView
                
            }
            
            view?.image = photoAnnotation.resizedImage
            
            return view
        }
        
        return nil
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
