

import MapKit
import UIKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate , CLLocationManagerDelegate {
    
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager!
    var data : DataConnection!
    
    override func viewDidLoad() {
        
        self.navigationController?.toolbar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        super.viewDidLoad()
        revealToggle()
        self.navigationController?.navigationBarHidden = true
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsUserLocation = true
        
        if activePlace == 1 {
            
            locationManager.requestWhenInUseAuthorization()
            //locationManager.startUpdatingLocation()
            data = DataConnection(typeOfBusiness: "")
            updateData()
            self.back.title = ""
            self.back.enabled = false
            
        } else {
            
            findAddressFromClickedButtonOnViewController()
            
        }
        
        var uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(uilpgr)
        
    }
    
    func revealToggle(){
        
        if self.revealViewController() != nil {
            
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
    }
    
    func updateData(){
        
        data.getData { (responseObject, error) -> Void in
            
            if  responseObject == nil{
                
                println("shit")
                
            } else {
                
                var parser = Parser(jsonFile: responseObject!)
                
                dispatch_async(dispatch_get_main_queue()){
                    
                    parser.parseForStreet()
                    self.findAddressFromJsonFile()
                   
                }
                
            }
            
            return
            
        }
        
    }
    
    func findAddressFromJsonFile(){
        
        for (var i = 0; i<addressArray.count; i++){
            
            var address = addressArray[i]
            var annotation = MKPointAnnotation()
            var geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
                
                if let placemark = placemarks?[0] as? CLPlacemark {
                    
                    self.mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake (placemark.location.coordinate.latitude, placemark.location.coordinate.longitude), MKCoordinateSpanMake(0.05, 0.05)), animated: true)
                    self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                    
                }
                
            })
            
            self.mapView.addAnnotation(annotation)
        
        }
    
    }
    
    func findAddressFromClickedButtonOnViewController(){
        
        var address : String?
        
            if activePlace == 2{
                
                address  = arrayOfLiquorStores[index!].address
                activePlace = 1
                
            } else {
                
                address = arrayOfBars[index!].address
                activePlace = 1
                
        }
        
        var annotation = MKPointAnnotation()
        var geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            
            if let placemark = placemarks?[0] as? CLPlacemark {
                
                self.mapView.setRegion(MKCoordinateRegionMake(CLLocationCoordinate2DMake (placemark.location.coordinate.latitude, placemark.location.coordinate.longitude), MKCoordinateSpanMake(0.002, 0.002)), animated: true)
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                
            }
            
        })
        
        self.mapView.addAnnotation(annotation)
        
    }
  
    func action(gestureRecognizer:UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            var touchPoint = gestureRecognizer.locationInView(self.mapView)
            
            var newCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            
            var location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                var title = ""
                var subTitle = ""
                
                if (error == nil) {
                    
                    if let p = CLPlacemark(placemark: placemarks?[0] as! CLPlacemark) {
                        var streetNumber:String = ""
                        var streetName:String = ""
                        
                        if p.subThoroughfare != nil {
                            
                            streetNumber = p.subThoroughfare
                        }
                        
                        if p.thoroughfare != nil {
                            
                            streetName = p.thoroughfare
                        }
                        
                        title = "\(streetNumber) \(streetName)"
                        subTitle = "\(p.subLocality)\(p.subAdministrativeArea),\(p.postalCode)"
                    }
                }
                if title == "" {
                    
                    title = "Added \(NSDate())"
                }
                
                var annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoordinate
                
                annotation.title = title
                annotation.subtitle = subTitle
                
                self.mapView.addAnnotation(annotation)
                
                
            })
        }
    }
    
 
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        
//        var userLocation:CLLocation = locations[0] as! CLLocation
//        
//        var latitude = userLocation.coordinate.latitude
//        
//        var longitude = userLocation.coordinate.longitude
//        
//        var coordinate = CLLocationCoordinate2DMake(latitude, longitude)
//        
//        var latDelta:CLLocationDegrees = 0.01
//        
//        var lonDelta:CLLocationDegrees = 0.01
//        
//        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
//        
//        var region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
//
//        self.mapView.setRegion(region, animated: true)
//        
//    }

    @IBAction func backButton(sender: AnyObject) {
        
        navigationController?.popToRootViewControllerAnimated(true)
        
    }
    

}
