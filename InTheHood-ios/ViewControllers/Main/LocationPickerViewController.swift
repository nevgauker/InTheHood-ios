//
//  LocationPickerViewController.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 06/06/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


extension LocationPickerViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        //1
        searchBar.resignFirstResponder()
        //dismiss(animated: true, completion: nil)
        if self.LocationMap.annotations.count != 0{
            annotation = self.LocationMap.annotations[0]
            self.LocationMap.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
//                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
//                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.LocationMap.centerCoordinate = self.pointAnnotation.coordinate
            self.LocationMap.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
}
   
   
    

extension LocationPickerViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.LocationMap.setRegion(region, animated: true)
        }
    }
    
}


class LocationPickerViewController: UIViewController {

    @IBOutlet weak var LocationMap: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    let locationManager = CLLocationManager()
    
    var localSearchRequest:MKLocalSearch.Request!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearch.Response!
    var annotation:MKAnnotation!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate  = self
        locationManager.requestWhenInUseAuthorization()

        // Do any additional setup after loading the view.
    }
    //MARK: actions
    
    @IBAction func didPressSelect(_ sender: Any) {
    }
    
    @IBAction func didPressBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
