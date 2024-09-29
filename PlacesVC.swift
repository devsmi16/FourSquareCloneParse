import UIKit
import ParseSwift
import ParseCore

class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var placesNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logOutClicked))
        

        tableView.dataSource = self
        tableView.delegate = self
        
        getDataFromParse()
    }
    
    func getDataFromParse (){
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { objects, error in
            if error != nil {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
            }else{
                if objects != nil {
                    
                    self.placesNameArray.removeAll(keepingCapacity: false)

                    
                    for object in objects! {
                        if let placeName = object.object(forKey: "name") as? String{
                            if let placeId = object.objectId{
                                self.placesNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func addButtonClicked(){
        self.performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
    }
    
    
    @objc func  logOutClicked(){
        PFUser.logOutInBackground { error in
            if error != nil {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
            }else{
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenPlaceId = selectedPlaceId
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    
    func makeAlert(titleInput: String,  messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
   

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placesNameArray[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesNameArray.count
    }
}
