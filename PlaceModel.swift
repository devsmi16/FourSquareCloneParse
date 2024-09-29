import Foundation
import UIKit

class PlaceModel {
    static let sharedInstance = PlaceModel()
    
    var longitude = ""
    var latitude = ""
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    
    private init(){
        
    }
}
