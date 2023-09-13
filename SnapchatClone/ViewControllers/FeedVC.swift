//
//  FeedViewController.swift
//  SnapchatClone
//
//  Created by Furkan Deniz Albaylar on 13.09.2023.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let fireBaseData  = Firestore.firestore()
    var snapArray = [Snap]()
    var chosenSnap : Snap?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        updateUI()
        getDataFromFirebase()

        // Do any additional setup after loading the view.
    }
    
    func updateUI(){
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(.init(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
    }
    func makeAlert(title: String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    func getDataFromFirebase(){
        fireBaseData.collection("Snaps").order(by: "date",descending: true).addSnapshotListener { snap, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "")
            }else {
                if snap?.isEmpty == false && snap != nil {
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snap!.documents {
                        
                        let documentId = document.documentID
                        if let username = document.get("snapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let date =  document.get("date") as? Timestamp {
                                    
                                    
                                    
                                    if let diffrence = Calendar.current.dateComponents([.hour], from: date.dateValue(),to: Date()).hour {
                                        if diffrence >= 24 {
                                            //
                                            self.fireBaseData.collection("Snaps").document(documentId).delete { error in
                                                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "")
                                            }
                                        }else {
                                            //TimeLeft
                                            let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDiffrence: 24-diffrence)
                                            self.snapArray.append(snap)
                                        }
                                    }
                                    
                                    
                                    
                                }
                            }
                        }
                        
                    }
                    self.tableView.reloadData()
                    
                    
                }
                
            }
        }
    }
    func getUserInfo(){
        fireBaseData.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser?.email!).getDocuments { snapShot, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "")
            }else {
                if snapShot?.isEmpty == false && snapShot != nil {
                    for document in snapShot!.documents {
                        if let username = document.get("username") as? String {
                            UserSingleton.sharedUserInfo.email = (Auth.auth().currentUser?.email)!
                            UserSingleton.sharedUserInfo.username = username
                            
                        }
                    }
                }
            }
        }
        
    }

}
extension FeedVC : UITableViewDelegate {
    
}
extension FeedVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        cell.feedUsernameLabel.text = snapArray[indexPath.row].username
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            let destinationVC = segue.destination as! SnapVC
            destinationVC.selectedSnap = chosenSnap
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
    
    
}
