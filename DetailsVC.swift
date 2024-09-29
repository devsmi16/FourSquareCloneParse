import UIKit
import MapKit
import ParseSwift
import ParseCore

class DetailsVC: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var placeAtmosphereLabel: UILabel!
    @IBOutlet weak var detailsMapView: MKMapView!
    
    var chosenPlaceId = ""
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDataFromParse()
        detailsMapView.delegate = self
    }
    
    func getDataFromParse(){
        //OBJECTS
        
        let query = PFQuery(className: "Places")
         query.whereKey("objectId", equalTo: chosenPlaceId)
         query.findObjectsInBackground { objects, error in
             if error != nil {
                  
             }else{
                 if objects != nil {
                     if objects!.count > 0 {
                         let chosenPlaceObject = objects![0]
                         
                         if let placeName = chosenPlaceObject.object(forKey: "name") as? String{
                             self.placeNameLabel.text = placeName
                         }
                         if let placeType = chosenPlaceObject.object(forKey: "type") as? String{
                             self.placeTypeLabel.text = placeType
                         }
                         if let placeAtmosphere = chosenPlaceObject.object(forKey: "atmosphere") as? String{
                             self.placeAtmosphereLabel.text = placeAtmosphere
                         }
                         
                         
                         if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String{
                             if let placeLatitudeDouble = Double(placeLatitude){
                                 self.chosenLatitude = placeLatitudeDouble
                             }
                         }
                         
                         if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String{
                             if let placeLongitudeDouble = Double(placeLongitude){
                                 self.chosenLongitude = placeLongitudeDouble
                             }
                         }
                         
                         if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject{
                             imageData.getDataInBackground { data, error in
                                 if error == nil {
                                     self.detailsImageView.image = UIImage(data: data!)
                                 }
                             }
                         }
                     }
                     
                     //MAPS
                     
                     let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                     
                     let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                     let region = MKCoordinateRegion(center: location, span: span)
                     
                     self.detailsMapView.setRegion(region, animated: true)
                     
                     let annotation = MKPointAnnotation()
                     annotation.coordinate = location
                     annotation.title = self.placeNameLabel.text!
                     annotation.subtitle = self.placeTypeLabel.text!
                     self.detailsMapView.addAnnotation(annotation)
                     
                 }
             }
         }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        }else{
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != 00 && self.chosenLongitude != 00 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks{
                    if placemark.count > 0 {
                        
                        let mKPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mKPlaceMark)
                        mapItem.name = self.placeNameLabel.text!
                        
                        
                        let launchOptins = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] // arabayla navigasyonu gösteriyor
                        mapItem.openInMaps(launchOptions: launchOptins)
                    }
                }
            }
        }
    }
}
