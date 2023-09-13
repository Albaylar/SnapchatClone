//
//  FeedViewController.swift
//  SnapchatClone
//
//  Created by Furkan Deniz Albaylar on 13.09.2023.
//

import UIKit
import Firebase

class FeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let fireBaseData  = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        // Do any additional setup after loading the view.
    }
    func updateUI(){
        tableView.dataSource = self
        tableView.delegate = self
        getUserInfo()
    }
    func makeAlert(title: String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
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
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
