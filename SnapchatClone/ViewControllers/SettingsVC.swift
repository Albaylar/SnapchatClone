//
//  SettingsVC.swift
//  SnapchatClone
//
//  Created by Furkan Deniz Albaylar on 13.09.2023.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func LogOutButtonClicked(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignInVC", sender: nil)
        }catch{
            print("Error")
            
        }
        
    }

}
