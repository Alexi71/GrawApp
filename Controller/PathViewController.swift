//
//  PathViewController.swift
//  GrawApp
//
//  Created by Alexander Kotik on 10.09.17.
//  Copyright © 2017 Alexander Kotik. All rights reserved.
//

import UIKit
import MapKit

class PathViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var dataItems:InpuDataController?
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //mapView.showsUserLocation = true
            //addAnnotationOfStation()
            //manager.startUpdatingLocation()
            addPath()
        }
        else {
            locationManager.requestWhenInUseAuthorization();
        }
    }
    
    func addPath() {
        var location : [CLLocationCoordinate2D] = []
        if let dataItems = dataItems {
            for data in dataItems.inputDataArray {
                location.append(CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude))
            }
        }
        if location.count > 0 {
            let polyLine = MKPolyline(coordinates: &location, count: location.count)
            mapView.add(polyLine)
            let region = MKCoordinateRegionMakeWithDistance(location[0], 200000, 200000)
            mapView.setRegion(region, animated: false)
        }
       
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2
            return renderer
            
        } else if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 3
            return renderer
            
        } else if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 2
            return renderer
        }
        
        return MKOverlayRenderer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
